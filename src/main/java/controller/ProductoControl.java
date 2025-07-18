package controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Producto;
import util.MySQLConexion;

public class ProductoControl {

    public List<Producto> listarProducto() {
        List<Producto> lista = new ArrayList<>();
        Connection cn = MySQLConexion.getConexion();

        try {
            String sql = "SELECT id_producto, nombre_producto, descripcion, unidad_medida, categoria, ruta_imagen FROM productos";
            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Producto p = new Producto();
                p.setId_producto(rs.getInt(1));
                p.setNombre_producto(rs.getString(2));
                p.setDescripcion(rs.getString(3));
                p.setUnidad_medida(rs.getString(4));
                p.setCategoria(rs.getString(5));
                p.setRuta_imagen(rs.getString(6));
                lista.add(p);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return lista;
    }

    public void AddProducto(String nombre, String descripcion, String unidad,
            String categoria, String rutaImagen) {
        Connection cn = MySQLConexion.getConexion();

        System.out.println("Insertando producto en BD..."); // Debug
        System.out.println("Ruta imagen: " + rutaImagen); // Debug

        try {
            String sql = "INSERT INTO productos (nombre_producto, descripcion, "
                    + "unidad_medida, categoria, ruta_imagen) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, nombre);
            st.setString(2, descripcion);
            st.setString(3, unidad);
            st.setString(4, categoria);
            st.setString(5, rutaImagen);

            int filas = st.executeUpdate();
            System.out.println("Filas afectadas: " + filas); // Debug

        } catch (Exception ex) {
            System.out.println("Error al insertar producto: " + ex.getMessage()); // Debug
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

    public Producto obtenerProductoPorId(int id) {
        Producto p = null;
        Connection cn = MySQLConexion.getConexion();

        try {
            String sql = "SELECT * FROM productos WHERE id_producto = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                p = new Producto();
                p.setId_producto(rs.getInt("id_producto"));
                p.setNombre_producto(rs.getString("nombre_producto"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setUnidad_medida(rs.getString("unidad_medida"));
                p.setCategoria(rs.getString("categoria"));
                p.setRuta_imagen(rs.getString("ruta_imagen"));
            }
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

        return p;
    }

    public boolean actualizarProducto(int id, String nombre, String descripcion,
            String unidad, String categoria, String rutaImagen) {
        Connection cn = null;
        try {
            cn = MySQLConexion.getConexion();
            String sql = "UPDATE productos SET "
                    + "nombre_producto = ?, "
                    + "descripcion = ?, "
                    + "unidad_medida = ?, "
                    + "categoria = ?, "
                    + "ruta_imagen = ? "
                    + "WHERE id_producto = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, nombre);
            st.setString(2, descripcion);
            st.setString(3, unidad);
            st.setString(4, categoria);
            st.setString(5, rutaImagen);
            st.setInt(6, id);

            int filasAfectadas = st.executeUpdate();
            return filasAfectadas > 0;

        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            if (cn != null) try {
                cn.close();
            } catch (Exception e) {
            }
        }
    }

    public boolean eliminarProducto(int id) {
        Connection cn = null;
        try {
            cn = MySQLConexion.getConexion();
            String sql = "DELETE FROM productos WHERE id_producto = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, id);

            int filasAfectadas = st.executeUpdate();
            return filasAfectadas > 0;

        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            if (cn != null) try {
                cn.close();
            } catch (Exception e) {
            }
        }
    }
}
