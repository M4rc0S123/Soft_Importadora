package controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Empleado;
import model.Rol;
import util.MySQLConexion;


public class LoginController {
    
    public Empleado validarUsuario(String usuario, String clave) {
        Empleado emp = null;
        String sql = "SELECT e.*, r.id_rol, r.nombre_rol FROM empleados e " +
                     "JOIN roles r ON e.id_rol = r.id_rol " +
                     "WHERE e.correo = ? AND e.contrasena = ? AND e.estado = true";
        
        try (Connection cn = MySQLConexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            ps.setString(1, usuario);
            ps.setString(2, clave);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Rol rol = new Rol();
                    rol.setId_rol(rs.getInt("id_rol"));
                    rol.setNombre_rol(rs.getString("nombre_rol"));
                    
                    emp = new Empleado();
                    emp.setId_empleado(rs.getInt("id_empleado"));
                    emp.setNombre(rs.getString("nombre"));
                    emp.setApellido(rs.getString("apellido"));
                    emp.setCorreo(rs.getString("correo"));
                    emp.setEstado(rs.getBoolean("estado"));
                    emp.setRol(rol);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return emp;
    }
}