
package controller;

import model.Almacen;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Importacion;
import util.MySQLConexion;

public class AlmacenController {

    // Listar todos los almacenes (versión corregida)
    public List<Almacen> listarAlmacenes() {
    List<Almacen> almacenes = new ArrayList<>();
    Connection cn = null;
    PreparedStatement st = null;
    ResultSet rs = null;
    
    try {
        cn = MySQLConexion.getConexion();
        if (cn == null) {
            System.err.println("Error: No se pudo obtener la conexión a la base de datos");
            return almacenes;
        }
        
        System.out.println("Obteniendo conexión...");
        String sql = "SELECT * FROM almacenes";   
        st = cn.prepareStatement(sql);
        rs = st.executeQuery();
        
        while (rs.next()) {
            Almacen almacen = new Almacen();
            almacen.setIdAlmacen(rs.getInt("id_almacen"));
            almacen.setIdImportacion(rs.getInt("id_importacion"));
            almacen.setFechaRecepcion(rs.getDate("fecha_recepcion"));
            almacen.setRecibidoPor(rs.getInt("recibido_por"));
            almacen.setObservaciones(rs.getString("observaciones"));
            almacen.setEstado(rs.getString("estado"));
            
            almacenes.add(almacen);
        }
        
        System.out.println("Total de almacenes encontrados: " + almacenes.size());
    } catch (SQLException e) {
        System.err.println("Error SQL en listarAlmacenes:");
        e.printStackTrace();
    } finally {
        // Cerrar recursos en orden inverso a su creación
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (st != null) st.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (cn != null) cn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    
    return almacenes;
}

    // Registrar nuevo almacén (versión corregida)
    public boolean registrarAlmacen(Almacen almacen) {
        String sql = "INSERT INTO almacenes (id_importacion, fecha_recepcion, recibido_por, observaciones, estado) " +
                   "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection cn = MySQLConexion.getConexion();
             PreparedStatement pstmt = cn.prepareStatement(sql)) {
            
            pstmt.setInt(1, almacen.getIdImportacion());
            pstmt.setDate(2, new java.sql.Date(almacen.getFechaRecepcion().getTime()));
            pstmt.setInt(3, almacen.getRecibidoPor());
            pstmt.setString(4, almacen.getObservaciones());
            pstmt.setString(5, almacen.getEstado());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Buscar almacén por ID (versión corregida)
    public Almacen buscarAlmacenPorId(int id) {
        String sql = "SELECT * FROM almacenes WHERE id_almacen = ?";
        
        try (Connection cn = MySQLConexion.getConexion();
             PreparedStatement pstmt = cn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Almacen almacen = new Almacen();
                    almacen.setIdAlmacen(rs.getInt("id_almacen"));
                    almacen.setIdImportacion(rs.getInt("id_importacion"));
                    almacen.setFechaRecepcion(rs.getDate("fecha_recepcion"));
                    almacen.setRecibidoPor(rs.getInt("recibido_por"));
                    almacen.setObservaciones(rs.getString("observaciones"));
                    almacen.setEstado(rs.getString("estado"));
                    
                    return almacen;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    // En tu AlmacenController.java
public List<Importacion> listarImportacionesParaAlmacen() {
    List<Importacion> importaciones = new ArrayList<>();
    String sql = "SELECT i.id_importacion, i.codigo_importacion, i.fecha_emision, " +
                "i.fecha_real_arribo, p.nombre_empresa as nombre_proveedor " +
                "FROM importaciones i " +
                "LEFT JOIN almacenes a ON i.id_importacion = a.id_importacion " +
                "JOIN proveedores p ON i.id_proveedor = p.id_proveedor " +
            "JOIN seguimientos_plazos s ON i.id_importacion = s.id_importacion " +
                "WHERE a.id_importacion IS NULL " + // No registrada en almacén
            "AND s.id_tipo_seguimiento = 7 " +
                "AND s.estado = 'completado' " +   // Completada en transporte
                "AND i.fecha_real_arribo IS NOT NULL"; // Con fecha de arribo real
    
    try (Connection cn = MySQLConexion.getConexion();
         PreparedStatement st = cn.prepareStatement(sql);
         ResultSet rs = st.executeQuery()) {
        
        while (rs.next()) {
            Importacion imp = new Importacion();
            imp.setId_importacion(rs.getInt("id_importacion"));
            imp.setCodigo_importacion(rs.getString("codigo_importacion"));
            imp.setFecha_emision(rs.getDate("fecha_emision"));
            imp.setFecha_real_arribo(rs.getDate("fecha_real_arribo"));
            // Puedes agregar más campos si los necesitas
            importaciones.add(imp);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return importaciones;
}
}