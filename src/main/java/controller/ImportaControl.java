
package controller;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.sql.Date; 
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import model.DetalleImporta;
import model.Importacion;
import model.SeguimientoPlazo;
import util.MySQLConexion;


public class ImportaControl {
    public List<Importacion> obtenerImportacionesPorFecha(java.sql.Date fecha) {
        
    List<Importacion> lista = new ArrayList<>();
    String sql = "SELECT * FROM importaciones WHERE fecha_emision = ?";
    Connection cn = null; // Declarar aquí
        PreparedStatement st = null; // Declarar aquí
        ResultSet rs = null; // Declarar aquí
    try {
         cn = MySQLConexion.getConexion();
            st = cn.prepareStatement(sql);

            st.setDate(1, fecha); // 'fecha' ya es java.sql.Date
            rs = st.executeQuery();

        while (rs.next()) {
            Importacion imp = new Importacion();
            imp.setId_importacion(rs.getInt("id_importacion"));
            imp.setCodigo_importacion(rs.getString("codigo_importacion"));
            imp.setFecha_emision(rs.getDate("fecha_emision"));
            imp.setFecha_estimada_arribo(rs.getDate("fecha_estimada_arribo"));
            imp.setFecha_real_arribo(rs.getDate("fecha_real_arribo"));
            imp.setEstado(rs.getString("estado"));
            imp.setId_proveedor(rs.getInt("id_proveedor"));
            imp.setResponsable(rs.getInt("responsable"));
            lista.add(imp);
        }

    } catch (Exception ex) {
            ex.printStackTrace();
        } finally { // Asegurar cierre de recursos
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (cn != null && !cn.isClosed()) cn.close();
            } catch (java.sql.SQLException ex) {
                ex.printStackTrace();
            }
        }
        return lista;
    }
     public Importacion obtenerImportacionPorId(int id) {
        Importacion imp = null;
        String sql = "SELECT * FROM importaciones WHERE id_importacion = ?";
        Connection cn = null; // Declarar aquí
        PreparedStatement st = null; // Declarar aquí
        ResultSet rs = null; // Declarar aquí
        
        try {

            cn = MySQLConexion.getConexion();
            st = cn.prepareStatement(sql);

            st.setInt(1, id);
            rs = st.executeQuery();

            if (rs.next()) {
                imp = new Importacion();
                imp.setId_importacion(rs.getInt("id_importacion"));
                imp.setCodigo_importacion(rs.getString("codigo_importacion"));
                imp.setFecha_emision(rs.getDate("fecha_emision"));
                imp.setFecha_estimada_arribo(rs.getDate("fecha_estimada_arribo"));
                imp.setFecha_real_arribo(rs.getDate("fecha_real_arribo"));
                imp.setEstado(rs.getString("estado"));
                imp.setId_proveedor(rs.getInt("id_proveedor"));
                imp.setResponsable(rs.getInt("responsable"));
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally { // Asegurar cierre de recursos
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (cn != null && !cn.isClosed()) cn.close();
            } catch (java.sql.SQLException ex) {
                ex.printStackTrace();
            }
        }
        return imp;
    }

    public int registrarImportacionConDetalles(String codigo, java.util.Date fecha_emision_util, java.util.Date fecha_estimada_util,
            String estado, int proveedor, int responsable,
            List<DetalleImporta> detalles) {
        java.sql.Date fecha_emision_sql = new java.sql.Date(fecha_emision_util.getTime());
        java.sql.Date fecha_estimada_sql = new java.sql.Date(fecha_estimada_util.getTime());

        int id_importacion_generado = insertarCabeceraImportacion(codigo, fecha_emision_sql, fecha_estimada_sql, estado, proveedor, responsable);
        if (id_importacion_generado > 0) {
            DetalleImportaControl detalleControl = new DetalleImportaControl();
            detalleControl.agregarDetallesImportacion(id_importacion_generado, detalles);
            // Si el método agregarDetallesImportacion fallara, aquí no se hace rollback
            // de la cabecera. Para un control transaccional completo, todo debería estar
            // en una única transacción de nivel superior, pero para este problema,
            // esta separación es adecuada.
        }
        return id_importacion_generado;
    }
    public List<Importacion> listarTodasLasImportaciones() {
    List<Importacion> lista = new ArrayList<>();
    String sql = "SELECT * FROM importaciones ORDER BY fecha_emision DESC";
    Connection cn = null;
    PreparedStatement st = null;
    ResultSet rs = null;
    
    try {
        cn = MySQLConexion.getConexion();
        st = cn.prepareStatement(sql);
        rs = st.executeQuery();

        while (rs.next()) {
            Importacion imp = new Importacion();
            imp.setId_importacion(rs.getInt("id_importacion"));
            imp.setCodigo_importacion(rs.getString("codigo_importacion"));
            imp.setFecha_emision(rs.getDate("fecha_emision"));
            imp.setFecha_estimada_arribo(rs.getDate("fecha_estimada_arribo"));
            imp.setFecha_real_arribo(rs.getDate("fecha_real_arribo"));
            imp.setEstado(rs.getString("estado"));
            imp.setId_proveedor(rs.getInt("id_proveedor"));
            imp.setResponsable(rs.getInt("responsable"));
            lista.add(imp);
        }
    } catch (Exception ex) {
        ex.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (cn != null && !cn.isClosed()) cn.close();
        } catch (java.sql.SQLException ex) {
            ex.printStackTrace();
        }
    }
    return lista;
}
    public List<Importacion> obtenerTodasLasImportaciones() {
    List<Importacion> lista = new ArrayList<>();
    String sql = "SELECT * FROM importaciones";
    Connection cn = null;
    PreparedStatement st = null;
    ResultSet rs = null;
    
    try {
        cn = MySQLConexion.getConexion();
        st = cn.prepareStatement(sql);
        rs = st.executeQuery();

        while (rs.next()) {
            Importacion imp = new Importacion();
            imp.setId_importacion(rs.getInt("id_importacion"));
            imp.setCodigo_importacion(rs.getString("codigo_importacion"));
            imp.setFecha_emision(rs.getDate("fecha_emision"));
            imp.setFecha_estimada_arribo(rs.getDate("fecha_estimada_arribo"));
            imp.setFecha_real_arribo(rs.getDate("fecha_real_arribo"));
            imp.setEstado(rs.getString("estado"));
            imp.setId_proveedor(rs.getInt("id_proveedor"));
            imp.setResponsable(rs.getInt("responsable"));
            lista.add(imp);
        }
    } catch (Exception ex) {
        ex.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (cn != null && !cn.isClosed()) cn.close();
        } catch (java.sql.SQLException ex) {
            ex.printStackTrace();
        }
    }
    return lista;
}
//
    private int insertarCabeceraImportacion(String codigo, Date fecha_emision, Date fecha_estimada_arribo,
                                           String estado, int id_proveedor, int responsable) {
        int idGenerado = -1;
        // La consulta SQL para insertar en la tabla 'importaciones'
        String sql = "INSERT INTO importaciones (codigo_importacion, fecha_emision, fecha_estimada_arribo, estado, id_proveedor, responsable) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        Connection cn = null;          // Declarar la conexión fuera del try-with-resources
        PreparedStatement pst = null; // Declarar el PreparedStatement fuera del try-with-resources
        ResultSet rs = null;          // Declarar el ResultSet fuera del try-with-resources

        try {
            cn = MySQLConexion.getConexion();
            // Preparar el PreparedStatement indicando que queremos las claves generadas (el ID auto-incrementado)
            pst = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            // Asignar los valores a los placeholders de la consulta
            pst.setString(1, codigo);
            pst.setDate(2, fecha_emision);
            pst.setDate(3, fecha_estimada_arribo);
            pst.setString(4, estado);
            pst.setInt(5, id_proveedor);
            pst.setInt(6, responsable);

            // Ejecutar la inserción. executeUpdate() devuelve el número de filas afectadas.
            int filasAfectadas = pst.executeUpdate();

            // Si la inserción fue exitosa (al menos una fila afectada), intentar obtener el ID generado
            if (filasAfectadas > 0) {
                rs = pst.getGeneratedKeys(); // Obtener el ResultSet que contiene los IDs generados
                if (rs.next()) {
                    idGenerado = rs.getInt(1); // Recuperar el primer (y único) ID generado
                }
            }

        } catch (Exception ex) {
            // Imprimir la pila de la excepción para depuración
            ex.printStackTrace();
        } finally {
            // Asegurarse de cerrar los recursos en el orden inverso de su creación
            // (ResultSet, PreparedStatement, Connection)
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (cn != null && !cn.isClosed()) {
                    cn.close(); // Cerrar la conexión
                }
            } catch (java.sql.SQLException ex) {
                ex.printStackTrace();
            }
        }
        return idGenerado;
    }
    public boolean actualizarFechaArribo(int idImportacion, String fechaReal) {
    String sql = "UPDATE importaciones SET fecha_real_arribo = ? WHERE id_importacion = ?";
    
    try (Connection cn = MySQLConexion.getConexion();
         PreparedStatement st = cn.prepareStatement(sql)) {
        
        // 1. Configurar la zona horaria ANTES de la conversión
        TimeZone.setDefault(TimeZone.getTimeZone("America/Lima")); // Ejemplo para Perú
        
        // Convertir String a java.sql.Date
        java.sql.Date fecha = null;
        if (fechaReal != null && !fechaReal.isEmpty()) {
            fecha = java.sql.Date.valueOf(fechaReal);
        }
        
        st.setDate(1, fecha);
        st.setInt(2, idImportacion);
        
        int filas = st.executeUpdate();
        return filas > 0;
        
    } catch (Exception ex) {
        System.err.println("Error al actualizar fecha real de arribo:");
        ex.printStackTrace();
        return false;
    }
}
    public int contarImportacionesPorEstado(String estado) {
    int total = 0;
    String sql = "SELECT COUNT(*) AS total FROM importaciones WHERE estado = ?";
    Connection cn = null;
    PreparedStatement st = null;
    ResultSet rs = null;
    
    try {
        cn = MySQLConexion.getConexion();
        st = cn.prepareStatement(sql);
        st.setString(1, estado);
        rs = st.executeQuery();
        
        if (rs.next()) {
            total = rs.getInt("total");
        }
    } catch (Exception ex) {
        ex.printStackTrace();
    } finally {
        // Cerrar recursos (rs, st, cn) como en tus otros métodos
    }
    return total;
}
   public List<Map<String, Object>> listarImportacionesCompletas() {
    List<Map<String, Object>> lista = new ArrayList<>();
    String sql = "SELECT i.id_importacion, i.codigo_importacion, i.estado, " +
                 "p.nombre_empresa AS nombre_proveedor, " +
                 "GROUP_CONCAT(DISTINCT pr.nombre_producto SEPARATOR ', ') AS productos " +
                 "FROM importaciones i " +
                 "LEFT JOIN proveedores p ON i.id_proveedor = p.id_proveedor " +
                 "LEFT JOIN detalle_importacion di ON i.id_importacion = di.id_importacion " +
                 "LEFT JOIN productos pr ON di.id_producto = pr.id_producto " +
                 "GROUP BY i.id_importacion, i.codigo_importacion, i.estado, p.nombre_empresa " +
                 "ORDER BY i.fecha_emision DESC " +
                 "LIMIT 5"; // Limitar a 5 registros para prueba

    try (Connection cn = MySQLConexion.getConexion();
         PreparedStatement st = cn.prepareStatement(sql);
         ResultSet rs = st.executeQuery()) {

        System.out.println("Ejecutando consulta: " + sql); // Log para depuración
        
        while (rs.next()) {
            Map<String, Object> fila = new HashMap<>();
            fila.put("codigo", rs.getString("codigo_importacion"));
            fila.put("proveedor", rs.getString("nombre_proveedor"));
            fila.put("productos", rs.getString("productos"));
            fila.put("estado", rs.getString("estado"));
            
            System.out.println("Registro encontrado: " + fila); // Log para depuración
            lista.add(fila);
        }
    } catch (Exception ex) {
        System.err.println("Error en listarImportacionesCompletas: ");
        ex.printStackTrace();
    }
    
    System.out.println("Total de registros encontrados: " + lista.size()); // Log para depuración
    return lista;
}
   
   public void actualizarEstadoImportacion(int idImportacion, List<SeguimientoPlazo> seguimientos) {
    String nuevoEstado = determinarEstado(seguimientos);
    actualizarEstado(idImportacion, nuevoEstado);
}

public String determinarEstado(List<SeguimientoPlazo> seguimientos) {
    boolean etapaAgenteCompletada = false;
    boolean etapaAlmacenCompletada = false;
    boolean algunaEtapaFallida = false;
    
    for (SeguimientoPlazo sp : seguimientos) {
        // Verificar si es la etapa de agente aduanal (tipo 4)
        if (sp.getIdTipoSeguimiento() == 4 && "Completado".equalsIgnoreCase(sp.getEstado())) {
            etapaAgenteCompletada = true;
        }
        
        // Verificar si es la etapa de almacén (tipo 7)
        if (sp.getIdTipoSeguimiento() == 7 && "Completado".equalsIgnoreCase(sp.getEstado())) {
            etapaAlmacenCompletada = true;
        }
        
        // Verificar si alguna etapa falló
        if ("Fallido".equalsIgnoreCase(sp.getEstado())) {
            algunaEtapaFallida = true;
        }
    }
    
    if (algunaEtapaFallida) {
        return "Cancelado";
    } else if (etapaAlmacenCompletada) {
        return "Recibido";
    } else if (etapaAgenteCompletada) {
        return "En Tránsito";
    } else {
        return "Pendiente";
    }
}

public boolean actualizarEstado(int idImportacion, String nuevoEstado) {
    String sql = "UPDATE importaciones SET estado = ? WHERE id_importacion = ?";
    
    try (Connection cn = MySQLConexion.getConexion();
         PreparedStatement st = cn.prepareStatement(sql)) {
        
        st.setString(1, nuevoEstado);
        st.setInt(2, idImportacion);
        
        int filas = st.executeUpdate();
        return filas > 0;
        
    } catch (Exception ex) {
        System.err.println("Error al actualizar estado de importación:");
        ex.printStackTrace();
        return false;
    }
}
   
}