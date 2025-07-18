/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
// controller/DevolucionControl.java
package controller;

import model.Devolucion;
import util.MySQLConexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DevolucionControl {
    private MySQLConexion conexion = new MySQLConexion();
    
    public boolean registrarDevolucion(Devolucion devolucion) {
        String sql = "INSERT INTO devoluciones_importacion (id_importacion, fecha_devolucion, motivo, responsable, estado) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, devolucion.getId_importacion());
            ps.setDate(2, devolucion.getFecha_devolucion());
            ps.setString(3, devolucion.getMotivo());
            ps.setString(4, devolucion.getResponsable());
            ps.setString(5, devolucion.getEstado());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public List<Devolucion> listarDevoluciones() {
    List<Devolucion> devoluciones = new ArrayList<>();
    String sql = "SELECT * FROM devoluciones_importacion ORDER BY id_devolucion ASC";
    
    try (Connection con = conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            Devolucion d = new Devolucion();
            d.setId_devolucion(rs.getInt("id_devolucion"));
            d.setId_importacion(rs.getInt("id_importacion"));
            d.setFecha_devolucion(rs.getDate("fecha_devolucion"));
            d.setMotivo(rs.getString("motivo"));
            d.setResponsable(rs.getString("responsable"));
            d.setEstado(rs.getString("estado"));
            devoluciones.add(d);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return devoluciones;
}
    public boolean existeDevolucionActivaParaImportacion(int idImportacion) {
    String sql = "SELECT COUNT(*) FROM devoluciones_importacion WHERE id_importacion = ? AND estado != 'cancelado'";
    
    try (Connection con = conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setInt(1, idImportacion);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
    public Devolucion obtenerDevolucionPorId(int idDevolucion) {
    String sql = "SELECT * FROM devoluciones_importacion WHERE id_devolucion = ?";
    Devolucion devolucion = null;
    
    try (Connection con = conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setInt(1, idDevolucion);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                devolucion = new Devolucion();
                devolucion.setId_devolucion(rs.getInt("id_devolucion"));
                devolucion.setId_importacion(rs.getInt("id_importacion"));
                devolucion.setFecha_devolucion(rs.getDate("fecha_devolucion"));
                devolucion.setMotivo(rs.getString("motivo"));
                devolucion.setResponsable(rs.getString("responsable"));
                devolucion.setEstado(rs.getString("estado"));
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return devolucion;
}

public boolean actualizarEstadoDevolucion(int idDevolucion, String nuevoEstado) {
    String sql = "UPDATE devoluciones_importacion SET estado = ? WHERE id_devolucion = ?";
    
    try (Connection con = conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, nuevoEstado);
        ps.setInt(2, idDevolucion);
        
        return ps.executeUpdate() > 0;
        
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
// En tu clase DevolucionControl (controller/DevolucionControl.java)
public int contarDevolucionesPorEstado(String estado) {
    String sql = "SELECT COUNT(*) FROM devoluciones_importacion WHERE estado = ?";
    try (Connection con = conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, estado);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}
}