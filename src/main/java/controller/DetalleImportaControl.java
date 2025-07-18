package controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.DetalleImporta;
import util.MySQLConexion;

public class DetalleImportaControl {

    public List<DetalleImporta> listaDetallePorImportacion(int idImportacion) {
        List<DetalleImporta> lista = new ArrayList<>();
        Connection cn = MySQLConexion.getConexion();
        try {
            String sql = "SELECT id_detalle, id_importacion, id_producto, cantidad, precio_unitario, subtotal "
                    + "FROM detalle_importacion WHERE id_importacion = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, idImportacion);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                DetalleImporta d = new DetalleImporta();
                d.setId_detalle(rs.getInt(1));
                d.setId_importacion(rs.getInt(2));
                d.setId_producto(rs.getInt(3));
                d.setCantidad(rs.getInt(4));
                d.setPrecio_unitario(rs.getDouble(5));
                d.setSubtotal(rs.getDouble(6));
                lista.add(d);
            }
            rs.close();
            st.close();
            cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public void agregarDetallesImportacion(int id_importacion, List<DetalleImporta> lista) {
        String sql = "INSERT INTO detalle_importacion (id_importacion, id_producto, cantidad, precio_unitario) VALUES (?, ?, ?, ?)";
        Connection cn = null;          // Declarar la conexión fuera del try-with-resources
        PreparedStatement pst = null; // Declarar el PreparedStatement fuera del try-with-resources

        try{
            cn = MySQLConexion.getConexion();
            pst = cn.prepareStatement(sql);

            cn.setAutoCommit(false); // **Iniciar Transacción:** Desactivar el auto-commit
            
            for (DetalleImporta d : lista) {
                pst.setInt(1, id_importacion);
                pst.setInt(2, d.getId_producto());
                pst.setInt(3, d.getCantidad());
                pst.setDouble(4, d.getPrecio_unitario());
                pst.addBatch();
            }
            pst.executeBatch(); // Ejecuta todas las inserciones del lote
            cn.commit(); // Confirma la transacción si todo fue bien

        } catch (Exception e) {
            e.printStackTrace();
            // En caso de cualquier error, hacer un rollback para deshacer todas las inserciones del lote
            try {
                if (cn != null) cn.rollback(); // 'cn' es accesible aquí para el rollback
            } catch (java.sql.SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            // Asegurarse de cerrar los recursos y restaurar el auto-commit
            try {
                if (pst != null) pst.close();
                if (cn != null && !cn.isClosed()) {
                    cn.setAutoCommit(true); // Restaurar el auto-commit al estado original (importante)
                    cn.close(); // Cerrar la conexión
                }
            } catch (java.sql.SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

}
