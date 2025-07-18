package controller;

import java.sql.*;
import java.util.ArrayList;
import java.util.*;
import model.Empleado;
import model.Rol;
import util.MySQLConexion;

public class EmpleadoControl {

    public List<Empleado> listarEmpleados() {
        List<Empleado> empleados = new ArrayList();

        String sql = "SELECT e.*, r.nombre_rol FROM empleados e JOIN roles r ON e.id_rol=r.id_rol";

        try (Connection cn = MySQLConexion.getConexion(); PreparedStatement stmt = cn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Rol rol = new Rol(rs.getInt("id_rol"), rs.getString("nombre_rol"));
                Empleado emp = new Empleado(
                        rs.getInt("id_empleado"),
                        rs.getString("nombre"),
                        rs.getString("apellido"),
                        rs.getString("correo"),
                        rs.getBoolean("estado"),
                        rol
                );
                empleados.add(emp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return empleados;
    }

    public void insertEmpleado(Empleado emp) {
        Connection cn = null;
        try {
            cn = MySQLConexion.getConexion();
            String sql = "INSERT INTO empleados(nombre, apellido, correo, contrasena, estado, id_rol) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement st = cn.prepareStatement(sql);

            st.setString(1, emp.getNombre());
            st.setString(2, emp.getApellido());
            st.setString(3, emp.getCorreo());
            st.setString(4, emp.getContrasena());
            st.setBoolean(5, emp.isEstado());
            st.setInt(6, emp.getRol().getId_rol());

            st.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    // Agrega estos métodos a tu clase EmpleadoControl

    public Empleado obtenerEmpleadoPorId(int id) {
        Empleado emp = null;
        try (Connection cn = MySQLConexion.getConexion()) {
            String sql = "SELECT e.*, r.nombre_rol FROM empleados e JOIN roles r ON e.id_rol=r.id_rol WHERE e.id_empleado=?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, id);

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                emp = new Empleado();
                emp.setId_empleado(rs.getInt("id_empleado"));
                emp.setNombre(rs.getString("nombre"));
                emp.setApellido(rs.getString("apellido"));
                emp.setCorreo(rs.getString("correo"));
                emp.setEstado(rs.getBoolean("estado"));

                Rol rol = new Rol();
                rol.setId_rol(rs.getInt("id_rol"));
                rol.setNombre_rol(rs.getString("nombre_rol"));
                emp.setRol(rol);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return emp;
    }

    public void actualizarEmpleado(Empleado emp) {
        Connection cn = null;
        try {
            cn = MySQLConexion.getConexion();
            String sql = "UPDATE empleados SET nombre=?, apellido=?, correo=?, estado=?, id_rol=? WHERE id_empleado=?";
            PreparedStatement st = cn.prepareStatement(sql);

            st.setString(1, emp.getNombre());
            st.setString(2, emp.getApellido());
            st.setString(3, emp.getCorreo());
            st.setBoolean(4, emp.isEstado());
            st.setInt(5, emp.getRol().getId_rol());
            st.setInt(6, emp.getId_empleado());

            st.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public List<Rol> listarRoles() {
        List<Rol> roles = new ArrayList<>();
        try (Connection cn = MySQLConexion.getConexion()) {
            String sql = "SELECT * FROM roles";
            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Rol rol = new Rol();
                rol.setId_rol(rs.getInt("id_rol"));
                rol.setNombre_rol(rs.getString("nombre_rol"));
                roles.add(rol);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roles;
    }

    public boolean eliminarEmpleado(int id) {
        boolean eliminado = false;
        Connection cn = null;
        try {
            cn = MySQLConexion.getConexion();
            // Usamos borrado lógico (cambiar estado a inactivo)
            String sql = "DELETE FROM empleados WHERE id_empleado = ?";
            // Para borrado físico usar: "DELETE FROM empleados WHERE id_empleado = ?"
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, id);

            int filas = st.executeUpdate();
            eliminado = filas > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return eliminado;
    }

}