/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import java.sql.*;
import java.util.ArrayList;
import java.util.*;
import model.Rol;
import util.MySQLConexion;


public class RolControl {
    public List<Rol> listarRoles(){
        List<Rol> roles=new ArrayList();
        
        String sql="SELECT id_rol, nombre_rol FROM roles";
        
        try(Connection cn = MySQLConexion.getConexion();
            PreparedStatement stmt = cn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {
            
            while(rs.next()){
                Rol rol=new Rol(
                
                rs.getInt("id_rol"),
                rs.getString("nombre_rol")
                );
                roles.add(rol);
            }
        }catch(SQLException e){
            e.printStackTrace();
        }
        return roles;
    }
    
    public void insertRol(Rol rol) {
        Connection cn = null;
        try {
            cn = MySQLConexion.getConexion();
            String sql = "INSERT INTO roles(nombre_rol) "
                       + "VALUES (?)";
            PreparedStatement st = cn.prepareStatement(sql);
            
            st.setString(1, rol.getNombre_rol());
            
            st.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    public Rol obtenerRolPorId(int id) {
    Rol rol = null;
    try (Connection cn = MySQLConexion.getConexion()) {
        String sql = "SELECT id_rol, nombre_rol FROM roles WHERE id_rol=?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, id);
        
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            rol = new Rol();
            rol.setId_rol(rs.getInt("id_rol"));
            rol.setNombre_rol(rs.getString("nombre_rol"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return rol;
}

public void actualizarRol(Rol rol) {
    Connection cn = null;
    try {
        cn = MySQLConexion.getConexion();
        String sql = "UPDATE roles SET nombre_rol=? WHERE id_rol=?";
        PreparedStatement st = cn.prepareStatement(sql);
        
        st.setString(1, rol.getNombre_rol());
        st.setInt(2, rol.getId_rol());
        
        st.executeUpdate();
    } catch (Exception ex) {
        ex.printStackTrace();
    } finally {
        try {
            if (cn != null) cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
public boolean eliminarRol(int id) {
    boolean eliminado = false;
    Connection cn = null;
    try {
        cn = MySQLConexion.getConexion();
        // Usamos borrado lógico (cambiar estado a inactivo)
        String sql = "DELETE FROM roles WHERE id_rol = ?";
        // Para borrado físico usar: "DELETE FROM empleados WHERE id_empleado = ?"
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, id);
        
        int filas = st.executeUpdate();
        eliminado = filas > 0;
    } catch (Exception ex) {
        ex.printStackTrace();
    } finally {
        try {
            if (cn != null) cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    return eliminado;
}

}
