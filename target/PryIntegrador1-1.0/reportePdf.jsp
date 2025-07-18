<%@page import="com.itextpdf.text.*, com.itextpdf.text.pdf.*, java.io.*, model.*, java.util.List, java.text.SimpleDateFormat, java.util.Date"%>
<%!
// Método auxiliar para crear celdas
private void addCell(PdfPTable table, String text, Font font, int alignment) {
    PdfPCell cell = new PdfPCell(new Phrase(text != null ? text : "", font));
    cell.setHorizontalAlignment(alignment);
    cell.setPadding(5);
    cell.setBorderWidth(0.5f);
    table.addCell(cell);
}

// Clase para manejar la imagen del gráfico en la celda
private class PdfPCellImage implements PdfPCellEvent {
    protected PdfTemplate template;
    
    public PdfPCellImage(PdfTemplate template) {
        this.template = template;
    }
    
    public void cellLayout(PdfPCell cell, Rectangle position, PdfContentByte[] canvases) {
        PdfContentByte cb = canvases[PdfPTable.BACKGROUNDCANVAS];
        cb.addTemplate(template, position.getLeft(), position.getBottom());
    }
}

// Método para añadir ítems a la leyenda
private void addLegendItem(PdfPTable table, String label, BaseColor color) {
    PdfPCell colorCell = new PdfPCell();
    colorCell.setFixedHeight(10);
    colorCell.setBorder(Rectangle.NO_BORDER);
    colorCell.setBackgroundColor(color);
    table.addCell(colorCell);
    
    PdfPCell labelCell = new PdfPCell(new Phrase(label, new Font(Font.FontFamily.HELVETICA, 8)));
    labelCell.setBorder(Rectangle.NO_BORDER);
    table.addCell(labelCell);
}

// Método para formatear fechas (ahora acepta Date)
private String formatDate(Date fecha) {
    if (fecha == null) {
        return "";
    }
    try {
        SimpleDateFormat displayFormat = new SimpleDateFormat("dd/MM/yyyy");
        return displayFormat.format(fecha);
    } catch (Exception e) {
        return "";
    }
}

// Método sobrecargado para manejar Strings también
private String formatDate(String dateString) {
    if (dateString == null || dateString.isEmpty()) {
        return "";
    }
    try {
        SimpleDateFormat dbFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat displayFormat = new SimpleDateFormat("dd/MM/yyyy");
        return displayFormat.format(dbFormat.parse(dateString));
    } catch (Exception e) {
        return dateString;
    }
}

// Método para dibujar una barra de Gantt
private void drawGanttBar(PdfContentByte cb, float x, float y, float width, BaseColor color, String label) {
    cb.saveState();
    cb.setColorFill(color);
    cb.rectangle(x, y - 5, width, 10);
    cb.fill();
    cb.restoreState();
    
    // Añadir etiqueta
    if (label != null && !label.isEmpty()) {
        ColumnText.showTextAligned(cb, Element.ALIGN_LEFT, 
            new Phrase(label, new Font(Font.FontFamily.HELVETICA, 8)), 
            x + width + 2, y, 0);
    }
}

// Método para obtener el color según el estado
private BaseColor getEstadoColor(String estado) {
    if (estado == null) return BaseColor.LIGHT_GRAY;
    
    switch(estado.toLowerCase()) {
        case "completado":
            return new BaseColor(0, 128, 0); // Verde
        case "en proceso":
            return new BaseColor(255, 165, 0); // Naranja
        case "retrasado":
            return BaseColor.RED;
        case "pendiente":
            return BaseColor.GRAY;
        default:
            return BaseColor.LIGHT_GRAY;
    }
}

// Método auxiliar para obtener fecha de la siguiente etapa
private Date obtenerFechaSiguienteEtapa(int tipoEtapaActual, Object[][] etapas, List<SeguimientoPlazo> seguimientos, SimpleDateFormat sdf) throws Exception {
    int siguienteTipo = tipoEtapaActual + 1;
    for (Object[] etapa : etapas) {
        if ((Integer)etapa[0] == siguienteTipo) {
            for (SeguimientoPlazo sp : seguimientos) {
                if (sp.getIdTipoSeguimiento() == siguienteTipo && sp.getFechaProgramada() != null) {
                    return sdf.parse(sp.getFechaProgramada());
                }
            }
            break;
        }
    }
    return null;
}
%>
<%
// Obtener datos del request
List<SeguimientoPlazo> seguimientos = (List<SeguimientoPlazo>) request.getAttribute("seguimientos");
Importacion importacion = (Importacion) request.getAttribute("importacion");

// Configurar respuesta
response.setContentType("application/pdf");
response.setHeader("Content-Disposition", "attachment; filename=seguimiento_"+importacion.getCodigo_importacion()+".pdf");

// Crear documento PDF (horizontal para mejor visualización)
Document document = new Document(PageSize.A4.rotate());
ByteArrayOutputStream baos = new ByteArrayOutputStream();
PdfWriter writer = PdfWriter.getInstance(document, baos);
document.open();

// Fuentes
Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
Font headerFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.WHITE);
Font normalFont = new Font(Font.FontFamily.HELVETICA, 10);
Font highlightFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.DARK_GRAY);
Font etapaFont = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD);

// Título
Paragraph title = new Paragraph("SEGUIMIENTO DE IMPORTACIÓN - DIAGRAMA DE GANTT", titleFont);
title.setAlignment(Element.ALIGN_CENTER);
title.setSpacingAfter(20);
document.add(title);

// Información de la importación
PdfPTable infoTable = new PdfPTable(2);
infoTable.setWidthPercentage(100);
infoTable.setSpacingBefore(10);
infoTable.setSpacingAfter(20);

// Estilo para celdas de información
PdfPCell infoCellStyle = new PdfPCell();
infoCellStyle.setBackgroundColor(new BaseColor(240, 240, 240));
infoCellStyle.setPadding(5);

addCell(infoTable, "Código Importación:", highlightFont, Element.ALIGN_RIGHT);
infoTable.addCell(infoCellStyle).setPhrase(new Phrase(importacion.getCodigo_importacion(), normalFont));

addCell(infoTable, "Estado:", highlightFont, Element.ALIGN_RIGHT);
infoTable.addCell(infoCellStyle).setPhrase(new Phrase(importacion.getEstado(), normalFont));

addCell(infoTable, "Fecha Emisión:", highlightFont, Element.ALIGN_RIGHT);
infoTable.addCell(infoCellStyle).setPhrase(new Phrase(formatDate(importacion.getFecha_emision()), normalFont));

addCell(infoTable, "Fecha Estimada Arribo:", highlightFont, Element.ALIGN_RIGHT);
infoTable.addCell(infoCellStyle).setPhrase(new Phrase(formatDate(importacion.getFecha_estimada_arribo()), normalFont));

if (importacion.getFecha_real_arribo() != null) {
    addCell(infoTable, "Fecha Real Arribo:", highlightFont, Element.ALIGN_RIGHT);
    infoTable.addCell(infoCellStyle).setPhrase(new Phrase(formatDate(importacion.getFecha_real_arribo()), normalFont));
}

document.add(infoTable);

// Diagrama de Gantt
Paragraph subtitle = new Paragraph("DIAGRAMA DE GANTT DEL SEGUIMIENTO", highlightFont);
subtitle.setAlignment(Element.ALIGN_CENTER);
subtitle.setSpacingAfter(10);
document.add(subtitle);

// Primero necesitamos determinar el rango de fechas
Date fechaInicio = importacion.getFecha_emision();
Date fechaFin = importacion.getFecha_estimada_arribo();

// Si hay una fecha real de arribo y es posterior a la estimada, la usamos como fin
if (importacion.getFecha_real_arribo() != null && 
    importacion.getFecha_real_arribo().after(importacion.getFecha_estimada_arribo())) {
    fechaFin = importacion.getFecha_real_arribo();
}

// Calcular la duración total en días
long duracionTotal = (fechaFin.getTime() - fechaInicio.getTime()) / (1000 * 60 * 60 * 24);
if (duracionTotal <= 0) duracionTotal = 1;

// Crear tabla para el diagrama de Gantt
PdfPTable ganttTable = new PdfPTable(2);
ganttTable.setWidthPercentage(100);
ganttTable.setWidths(new float[]{2, 8});
ganttTable.setSpacingBefore(15);
ganttTable.setSpacingAfter(20);

// Definir etapas
Object[][] etapas = {
    {1, "Proveedor"}, {2, "Embarque"}, {3, "Puerto Destino"},
    {4, "Agente Aduanal"}, {5, "Aduana"}, {6, "Transporte"}, {7, "Almacén"}
};

// Obtener el objeto PdfContentByte para dibujar directamente
PdfContentByte cb = writer.getDirectContent();

// Margen izquierdo para el gráfico
float marginLeft = 100;
float yPosition = 0;
float startY = 0;

for (Object[] etapa : etapas) {
    String nombreEtapa = (String)etapa[1];
    int tipoEtapa = (Integer)etapa[0];
    
    // Celda con el nombre de la etapa
    PdfPCell etapaCell = new PdfPCell(new Phrase(nombreEtapa, etapaFont));
    etapaCell.setBorder(Rectangle.NO_BORDER);
    etapaCell.setPadding(5);
    ganttTable.addCell(etapaCell);
    
    // Celda con el gráfico
    PdfPCell graphCell = new PdfPCell();
    graphCell.setBorder(Rectangle.NO_BORDER);
    graphCell.setFixedHeight(30); // Altura fija para cada fila
    
    SeguimientoPlazo sp = null;
    if (seguimientos != null) {
        for (SeguimientoPlazo s : seguimientos) {
            if (s.getIdTipoSeguimiento() == tipoEtapa) {
                sp = s;
                break;
            }
        }
    }
    
    // Crear un template para dibujar en esta celda
    PdfTemplate template = cb.createTemplate(500, 30);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    if (sp != null) {
        try {
            // Convertir fechas a objetos Date
            Date fechaProgramada = sp.getFechaProgramada() != null ? sdf.parse(sp.getFechaProgramada()) : null;
            Date fechaReal = sp.getFechaReal() != null && !sp.getFechaReal().isEmpty() ? sdf.parse(sp.getFechaReal()) : null;
            
            // Calcular posiciones relativas
            float xStart = 0;
            float xEnd = 0;
            
            if (fechaProgramada != null) {
                long diasDesdeInicio = (fechaProgramada.getTime() - fechaInicio.getTime()) / (1000 * 60 * 60 * 24);
                xStart = (float)diasDesdeInicio / duracionTotal * 450; // 450 es el ancho máximo del gráfico
                
                // Dibujar línea programada
                template.setLineWidth(1);
                template.setColorStroke(BaseColor.BLACK);
                template.moveTo(xStart, 15);
                template.lineTo(xStart + 30, 15); // Longitud fija para la programación
                template.stroke();
                
                // Etiqueta de fecha programada
                ColumnText.showTextAligned(template, Element.ALIGN_LEFT, 
                    new Phrase(formatDate(fechaProgramada), new Font(Font.FontFamily.HELVETICA, 7)), 
                    xStart, 25, 0);
                
                // Lógica modificada para barras de Gantt
                if ("completado".equalsIgnoreCase(sp.getEstado())) {
                    // Para etapas completadas, extender hasta la siguiente etapa
                    Date fechaSiguienteEtapa = obtenerFechaSiguienteEtapa(tipoEtapa, etapas, seguimientos, sdf);
                    if (fechaSiguienteEtapa != null) {
                        long diasHastaSiguiente = (fechaSiguienteEtapa.getTime() - fechaInicio.getTime()) / (1000 * 60 * 60 * 24);
                        xEnd = (float)diasHastaSiguiente / duracionTotal * 450;
                    } else {
                        // Si no hay siguiente etapa, usar fecha real o programada + margen
                        xEnd = fechaReal != null ? 
                            ((float)(fechaReal.getTime() - fechaInicio.getTime()) / (1000 * 60 * 60 * 24) / duracionTotal * 450) : 
                            xStart + 30;
                    }
                } else {
                    // Para otros estados, usar la fecha real si existe
                    xEnd = fechaReal != null ? 
                        ((float)(fechaReal.getTime() - fechaInicio.getTime()) / (1000 * 60 * 60 * 24) / duracionTotal * 450) : 
                        xStart + 30;
                }
                
                // Asegurarse de que el ancho mínimo sea de 10 unidades
                float barWidth = Math.max(10, xEnd - xStart);
                drawGanttBar(template, xStart, 15, barWidth, getEstadoColor(sp.getEstado()), sp.getEstado());
                
                // Etiqueta de estado
                if (fechaReal != null) {
                    ColumnText.showTextAligned(template, Element.ALIGN_LEFT, 
                        new Phrase(formatDate(fechaReal), new Font(Font.FontFamily.HELVETICA, 7)), 
                        xEnd, 5, 0);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        // Dibujar línea punteada para etapas sin seguimiento
        template.setLineWidth(1);
        template.setColorStroke(BaseColor.LIGHT_GRAY);
        template.setLineDash(3, 2);
        template.moveTo(0, 15);
        template.lineTo(450, 15);
        template.stroke();
    }
    
    // Dibujar línea de tiempo base
    template.setLineWidth(0.5f);
    template.setColorStroke(BaseColor.BLACK);
    template.setLineDash(0);
    template.moveTo(0, 10);
    template.lineTo(450, 10);
    template.stroke();
    
    // Añadir el template a la celda
    graphCell.setCellEvent(new PdfPCellImage(template));
    ganttTable.addCell(graphCell);
}

document.add(ganttTable);

// Leyenda del diagrama
PdfPTable legendTable = new PdfPTable(5);
legendTable.setWidthPercentage(50);
legendTable.setHorizontalAlignment(Element.ALIGN_CENTER);
legendTable.setSpacingBefore(10);

addLegendItem(legendTable, "Completado", getEstadoColor("Completado"));
addLegendItem(legendTable, "En Proceso", getEstadoColor("En Proceso"));
addLegendItem(legendTable, "Retrasado", getEstadoColor("Retrasado"));
addLegendItem(legendTable, "Pendiente", getEstadoColor("Pendiente"));
addLegendItem(legendTable, "No iniciado", BaseColor.LIGHT_GRAY);

document.add(legendTable);

// Pie de página
Paragraph footer = new Paragraph("\nGenerado el: " + new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date()), normalFont);
footer.setAlignment(Element.ALIGN_RIGHT);
document.add(footer);

document.close();

// Escribir PDF
ServletOutputStream outputStream = response.getOutputStream();
baos.writeTo(outputStream);
outputStream.flush();
outputStream.close();
%>