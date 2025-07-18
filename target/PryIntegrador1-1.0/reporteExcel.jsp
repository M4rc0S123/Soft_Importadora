<%@page import="org.apache.poi.ss.usermodel.*, 
                org.apache.poi.xssf.usermodel.*, 
                org.apache.poi.ss.util.CellRangeAddress,
                java.io.*, 
                model.*, 
                java.util.List, 
                java.text.SimpleDateFormat, 
                java.util.Date,
                java.util.Calendar"%>
<%!
// Método seguro para parsear fechas desde String
private Date parsearFecha(String fechaStr, String formato, Date defaultDate) {
    if (fechaStr == null || fechaStr.trim().isEmpty()) {
        return defaultDate;
    }
    try {
        return new SimpleDateFormat(formato).parse(fechaStr);
    } catch (Exception e) {
        return defaultDate;
    }
}

// Método para calcular día relativo
private int calcularDiaRelativo(Date fecha, Date fechaInicioProyecto) {
    if (fecha == null || fechaInicioProyecto == null) return 0;
    long diff = fecha.getTime() - fechaInicioProyecto.getTime();
    return (int)(diff / (1000 * 60 * 60 * 24)) + 1;
}

// Método para crear estilo de celda de Gantt
private CellStyle crearEstiloGantt(XSSFWorkbook workbook, String estado) {
    CellStyle style = workbook.createCellStyle();
    style.setBorderLeft(BorderStyle.THIN);
    style.setBorderRight(BorderStyle.THIN);
    
    if (estado == null) estado = "";
    
    switch(estado.toLowerCase()) {
        case "completado":
            style.setFillForegroundColor(IndexedColors.GREEN.getIndex());
            break;
        case "en proceso":
            style.setFillForegroundColor(IndexedColors.BLUE.getIndex());
            break;
        case "retrasado":
            style.setFillForegroundColor(IndexedColors.RED.getIndex());
            break;
        case "pendiente":
            style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            break;
        default:
            style.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
    }
    style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
    return style;
}
%>
<%
List<SeguimientoPlazo> seguimientos = (List<SeguimientoPlazo>) request.getAttribute("seguimientos");
Importacion importacion = (Importacion) request.getAttribute("importacion");

response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
response.setHeader("Content-Disposition", "attachment; filename=diagrama_gantt_"+importacion.getCodigo_importacion()+".xlsx");

// 1. Configuración inicial
XSSFWorkbook workbook = new XSSFWorkbook();
XSSFSheet sheet = workbook.createSheet("Gantt Profesional");

// 2. Manejo robusto de fechas del proyecto
Date hoy = new Date();
Date fechaInicioProyecto = hoy;
Date fechaFinProyecto = hoy;

// Obtener fechas de la importación (manejo seguro)
String fechaEmisionStr = importacion.getFecha_emision() != null ? importacion.getFecha_emision().toString() : "";
String fechaArriboStr = importacion.getFecha_estimada_arribo() != null ? importacion.getFecha_estimada_arribo().toString() : "";

fechaInicioProyecto = parsearFecha(fechaEmisionStr, "yyyy-MM-dd", hoy);

Calendar cal = Calendar.getInstance();
cal.setTime(fechaInicioProyecto);
cal.add(Calendar.MONTH, 1); // Fecha fin por defecto: 1 mes después
fechaFinProyecto = parsearFecha(fechaArriboStr, "yyyy-MM-dd", cal.getTime());

// Asegurar que fecha fin sea posterior a fecha inicio
if (fechaFinProyecto.before(fechaInicioProyecto)) {
    fechaFinProyecto = fechaInicioProyecto;
}

// 3. Crear estilos
CellStyle headerStyle = workbook.createCellStyle();
Font headerFont = workbook.createFont();
headerFont.setBold(true);
headerFont.setColor(IndexedColors.WHITE.getIndex());
headerStyle.setFont(headerFont);
headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
headerStyle.setAlignment(HorizontalAlignment.CENTER);

CellStyle dateStyle = workbook.createCellStyle();
dateStyle.setDataFormat(workbook.getCreationHelper().createDataFormat().getFormat("dd-mmm-yy"));

// 4. Crear estructura del Gantt
Row headerRow1 = sheet.createRow(0);
Row headerRow2 = sheet.createRow(1);

// Configurar columnas
sheet.setColumnWidth(0, 5000); // Columna de actividades
sheet.setColumnWidth(1, 3000); // Columna de estado
sheet.setColumnWidth(2, 3000); // Columna de inicio
sheet.setColumnWidth(3, 3000); // Columna de fin

// Encabezados principales
String[] headers = {"Actividad", "Estado", "Inicio", "Fin", "Duración (días)"};
for (int i = 0; i < headers.length; i++) {
    Cell cell = headerRow1.createCell(i);
    cell.setCellValue(headers[i]);
    cell.setCellStyle(headerStyle);
    
    if (i == headers.length - 1) {
        sheet.addMergedRegion(new CellRangeAddress(0, 1, i, i + 30));
    }
}

// Encabezados de días
Calendar calDias = Calendar.getInstance();
calDias.setTime(fechaInicioProyecto);
for (int i = 0; i < 30; i++) {
    Cell dayCell = headerRow2.createCell(headers.length + i);
    dayCell.setCellValue(calDias.get(Calendar.DAY_OF_MONTH));
    dayCell.setCellStyle(headerStyle);
    calDias.add(Calendar.DAY_OF_MONTH, 1);
}

// 5. Llenar datos de actividades
Object[][] etapas = {
    {1, "Proveedor"}, {2, "Embarque"}, {3, "Puerto Destino"},
    {4, "Agente Aduanal"}, {5, "Aduana"}, {6, "Transporte"}, {7, "Almacén"}
};

int rowNum = 2; // Empezar después de los encabezados
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

for (Object[] etapa : etapas) {
    Row row = sheet.createRow(rowNum++);
    
    // Nombre de la actividad
    row.createCell(0).setCellValue((String)etapa[1]);
    
    // Buscar seguimiento
    SeguimientoPlazo sp = null;
    if (seguimientos != null) {
        for (SeguimientoPlazo s : seguimientos) {
            if (s.getIdTipoSeguimiento() == (Integer)etapa[0]) {
                sp = s;
                break;
            }
        }
    }
    
    if (sp != null) {
        // Estado con color
        Cell estadoCell = row.createCell(1);
        estadoCell.setCellValue(sp.getEstado());
        estadoCell.setCellStyle(crearEstiloGantt(workbook, sp.getEstado()));
        
        try {
            // Fechas
            Date fechaInicio = sdf.parse(sp.getFechaProgramada());
            Date fechaFin = sp.getFechaReal() != null ? sdf.parse(sp.getFechaReal().toString()) : fechaInicio;
            
            Cell inicioCell = row.createCell(2);
            inicioCell.setCellValue(fechaInicio);
            inicioCell.setCellStyle(dateStyle);
            
            Cell finCell = row.createCell(3);
            finCell.setCellValue(fechaFin);
            finCell.setCellStyle(dateStyle);
            
            // Duración
            long duracion = (fechaFin.getTime() - fechaInicio.getTime()) / (1000 * 60 * 60 * 24);
            row.createCell(4).setCellValue(duracion + " días");
            
            // Barras de Gantt
            int startDay = calcularDiaRelativo(fechaInicio, fechaInicioProyecto);
            int endDay = calcularDiaRelativo(fechaFin, fechaInicioProyecto);
            
            for (int i = 0; i < 30; i++) {
                Cell ganttCell = row.createCell(headers.length + i);
                if (i + 1 >= startDay && i + 1 <= endDay) {
                    ganttCell.setCellStyle(crearEstiloGantt(workbook, sp.getEstado()));
                    ganttCell.setCellValue("?");
                }
            }
            
        } catch (Exception e) {
            row.createCell(2).setCellValue("Error en fechas");
        }
    } else {
        // Actividad sin seguimiento
        row.createCell(1).setCellValue("Pendiente");
        row.createCell(1).setCellStyle(crearEstiloGantt(workbook, "pendiente"));
    }
}

// 6. Añadir leyenda
Row leyendaRow = sheet.createRow(rowNum++);
leyendaRow.createCell(0).setCellValue("Leyenda:");
leyendaRow.getCell(0).setCellStyle(headerStyle);

String[] estados = {"Completado", "En Proceso", "Retrasado", "Pendiente"};
for (int i = 0; i < estados.length; i++) {
    Cell estadoCell = leyendaRow.createCell(i + 1);
    estadoCell.setCellValue(estados[i]);
    estadoCell.setCellStyle(crearEstiloGantt(workbook, estados[i]));
}

// 7. Congelar paneles
sheet.createFreezePane(0, 2);

// 8. Escribir el archivo
ServletOutputStream outputStream = response.getOutputStream();
workbook.write(outputStream);
workbook.close();
outputStream.close();
%>