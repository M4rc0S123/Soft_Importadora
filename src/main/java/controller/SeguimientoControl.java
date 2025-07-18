/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.SeguimientoPlazo;
import util.MySQLConexion;


public class SeguimientoControl {
      public List<SeguimientoPlazo> obtenerSeguimientosPorImportacion(int idImportacion) {
        List<SeguimientoPlazo> seguimientos = new ArrayList<>();
        String sql = "SELECT sp.*, ts.nombre as tipo_nombre " +
                     "FROM seguimientos_plazos sp " +
                     "JOIN tipos_seguimiento ts ON sp.id_tipo_seguimiento = ts.id_tipo " +
                     "WHERE sp.id_importacion = ?";
        System.out.println("[DEBUG SQL] Consulta: " + sql);
        System.out.println("[DEBUG SQL] Parámetro ID Importación: " + idImportacion);
        
        try (Connection cn = MySQLConexion.getConexion();
             PreparedStatement st = cn.prepareStatement(sql)) {
            
            st.setInt(1, idImportacion);
            ResultSet rs = st.executeQuery();
                while (rs.next()) {
                    SeguimientoPlazo sp = new SeguimientoPlazo();
            sp.setIdSeguimiento(rs.getInt("id_seguimiento"));
            sp.setIdImportacion(rs.getInt("id_importacion"));
            sp.setIdTipoSeguimiento(rs.getInt("id_tipo_seguimiento"));
            sp.setTipoNombre(rs.getString("tipo_nombre")); // Asegúrate de setear el nombre del tipo
            sp.setFechaProgramada(rs.getString("fecha_programada"));
            sp.setFechaReal(rs.getString("fecha_real"));
            sp.setResponsable(rs.getInt("responsable"));
            sp.setObservaciones(rs.getString("observaciones"));
            sp.setEstado(rs.getString("estado"));
            
            // Depuración detallada
            System.out.println("[DEBUG DATA] Seguimiento cargado - " +
                "ID: " + sp.getIdSeguimiento() + ", " +
                "Tipo: " + sp.getIdTipoSeguimiento() + " (" + sp.getTipoNombre() + "), " +
                "Estado: " + sp.getEstado());
            
            seguimientos.add(sp);
            }
                System.out.println("[DEBUG RESULT] Total seguimientos encontrados: " + seguimientos.size());
        } catch (Exception ex) {
            System.err.println("[ERROR SQL] Error al obtener seguimientos:");
            System.err.println("Mensaje: " + ex.getMessage());
            ex.printStackTrace();
        }
        
        return seguimientos;
    }
    // En tu clase SeguimientoControl
public boolean actualizarSeguimiento(int idSeguimiento, String estado, String fechaReal, String observaciones) {
    Connection cn = null;
    PreparedStatement st = null;
    
    try {
        cn = MySQLConexion.getConexion();
        cn.setAutoCommit(false);
        
        // 1. Obtener el seguimiento ACTUAL antes de modificarlo
        SeguimientoPlazo segActual = this.obtenerSeguimientoPorId(idSeguimiento);
        if (segActual == null) {
            cn.rollback();
            return false;
        }
    
    
    String sql = "UPDATE seguimientos_plazos SET estado = ?, fecha_real = ?, observaciones = ? WHERE id_seguimiento = ?";
    
    System.out.println("[DEBUG] Ejecutando actualización:");
    System.out.println("ID Seguimiento: " + idSeguimiento);
    System.out.println("Estado: " + estado);
    System.out.println("Fecha Real: " + fechaReal);
    System.out.println("Observaciones: " + observaciones);
    
        st = cn.prepareStatement(sql);
        st.setString(1, estado);
        st.setString(2, fechaReal.isEmpty() ? null : fechaReal);
        st.setString(3, observaciones);
        st.setInt(4, idSeguimiento);
        
        int filas = st.executeUpdate();
        System.out.println("[DEBUG] Filas afectadas: " + filas);
        
        if (filas > 0) {
            
            // 2. Obtener todos los seguimientos para esta importación
            List<SeguimientoPlazo> seguimientos = this.obtenerSeguimientosPorImportacion(segActual.getIdImportacion());
            
            // 3. Actualizar el estado de la importación según las reglas
            ImportaControl importaControl = new ImportaControl();
            importaControl.actualizarEstadoImportacion(segActual.getIdImportacion(), seguimientos);
            
            // 2. Obtener datos del seguimiento para verificar si debemos actualizar la importación
            boolean esCambioRelevante = 
                ("Completado".equalsIgnoreCase(estado) && segActual.getIdTipoSeguimiento() == 7) || 
                "Fallido".equalsIgnoreCase(estado);
            
            // 4. Solo actualizar fecha_real_arribo si:
            // - Es un cambio relevante Y
            // - El estado ANTERIOR era diferente (evitar duplicados)
            if (esCambioRelevante && !estado.equalsIgnoreCase(segActual.getEstado())) {
                
                boolean actualizado = importaControl.actualizarFechaArribo(
                    segActual.getIdImportacion(), 
                    fechaReal.isEmpty() ? null : fechaReal // Usar la NUEVA fecha
                );
                
                if (!actualizado) {
                    cn.rollback();
                    return false;
                }
            }
            
            cn.commit();
            return true;
        }
        
        cn.rollback();
        return false;
        
    } catch (Exception ex) {
        try { if (cn != null) cn.rollback(); } catch (Exception e) {}
        System.err.println("Error al actualizar seguimiento:");
        ex.printStackTrace();
        return false;
    } finally {
        try { if (st != null) st.close(); } catch (Exception e) {}
        try { if (cn != null) cn.close(); } catch (Exception e) {}
    }
}
public boolean registrarSeguimiento(SeguimientoPlazo seguimiento) {
        // Validar que la etapa anterior esté completada (excepto para la primera etapa)
        if (seguimiento.getIdTipoSeguimiento() > 1 && !verificarEtapaAnteriorCompletada(seguimiento.getIdTipoSeguimiento(), seguimiento.getIdImportacion())) {
            System.out.println("[VALIDATION] La etapa anterior no está completada");
            return false;
        }
        
        String sql = "INSERT INTO seguimientos_plazos (id_importacion, id_tipo_seguimiento, fecha_programada, " +
                     "fecha_real, responsable, observaciones, estado) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;
    
        try {
        cn = MySQLConexion.getConexion();
        cn.setAutoCommit(false);
        
            st = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            st.setInt(1, seguimiento.getIdImportacion());
            st.setInt(2, seguimiento.getIdTipoSeguimiento());
            st.setString(3, seguimiento.getFechaProgramada());
            st.setString(4, seguimiento.getFechaReal());
            st.setInt(5, seguimiento.getResponsable());
            st.setString(6, seguimiento.getObservaciones());
            st.setString(7, seguimiento.getEstado());
            
            int filas = st.executeUpdate();
            if (filas > 0) {
            // Verificar si debemos actualizar la fecha de arribo
            if ("Completado".equalsIgnoreCase(seguimiento.getEstado()) && seguimiento.getIdTipoSeguimiento() == 7 || 
                "Fallido".equalsIgnoreCase(seguimiento.getEstado())) {
                
                ImportaControl importaControl = new ImportaControl();
                boolean actualizado = importaControl.actualizarFechaArribo(
                    seguimiento.getIdImportacion(), 
                    seguimiento.getFechaReal()
                );
                
                if (!actualizado) {
                    cn.rollback();
                    return false;
                }
            }
            
            cn.commit();
            return true;
        }
        
        cn.rollback();
        return false;
        
    } catch (Exception ex) {
        try { if (cn != null) cn.rollback(); } catch (Exception e) {}
        System.err.println("Error al registrar seguimiento:");
        ex.printStackTrace();
        return false;
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (st != null) st.close(); } catch (Exception e) {}
        try { if (cn != null) cn.close(); } catch (Exception e) {}
    }
}

    public boolean verificarEtapaAnteriorCompletada(int tipoActual, int idImportacion) {
        if (tipoActual == 1) return true; // La primera etapa siempre está disponible
        
        String sql = "SELECT estado FROM seguimientos_plazos WHERE id_tipo_seguimiento = ? AND id_importacion = ?";
        
        try (Connection cn = MySQLConexion.getConexion();
             PreparedStatement st = cn.prepareStatement(sql)) {
            
            st.setInt(1, tipoActual - 1);
            st.setInt(2, idImportacion);
            
            ResultSet rs = st.executeQuery();
            return rs.next() && "Completado".equalsIgnoreCase(rs.getString("estado"));
            
        } catch (Exception ex) {
            System.err.println("Error al verificar etapa anterior:");
            ex.printStackTrace();
            return false;
        }
    }

    public boolean tieneEtapasSiguientes(int tipoActual, int idImportacion) {
        String sql = "SELECT COUNT(*) FROM seguimientos_plazos WHERE id_tipo_seguimiento > ? AND id_importacion = ?";
        
        try (Connection cn = MySQLConexion.getConexion();
             PreparedStatement st = cn.prepareStatement(sql)) {
            
            st.setInt(1, tipoActual);
            st.setInt(2, idImportacion);
            
            ResultSet rs = st.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
            
        } catch (Exception ex) {
            System.err.println("Error al verificar etapas siguientes:");
            ex.printStackTrace();
            return false;
        }
    }

    public SeguimientoPlazo obtenerSeguimientoPorId(int idSeguimiento) {
        String sql = "SELECT sp.*, ts.nombre as tipo_nombre FROM seguimientos_plazos sp " +
                     "JOIN tipos_seguimiento ts ON sp.id_tipo_seguimiento = ts.id_tipo " +
                     "WHERE sp.id_seguimiento = ?";
        
        try (Connection cn = MySQLConexion.getConexion();
             PreparedStatement st = cn.prepareStatement(sql)) {
            
            st.setInt(1, idSeguimiento);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                SeguimientoPlazo sp = new SeguimientoPlazo();
                sp.setIdSeguimiento(rs.getInt("id_seguimiento"));
                sp.setIdImportacion(rs.getInt("id_importacion"));
                sp.setIdTipoSeguimiento(rs.getInt("id_tipo_seguimiento"));
                sp.setTipoNombre(rs.getString("tipo_nombre"));
                sp.setFechaProgramada(rs.getString("fecha_programada"));
                sp.setFechaReal(rs.getString("fecha_real"));
                sp.setResponsable(rs.getInt("responsable"));
                sp.setObservaciones(rs.getString("observaciones"));
                sp.setEstado(rs.getString("estado"));
                return sp;
            }
            return null;
            
        } catch (Exception ex) {
            System.err.println("Error al obtener seguimiento por ID:");
            ex.printStackTrace();
            return null;
        }
    }
    public Map<String, Integer> contarPlazosPorEtapas() {
    Map<String, Integer> contadores = new HashMap<>();
    contadores.put("enProceso", 0);
    contadores.put("completos", 0);
    contadores.put("retrasados", 0);
    
    String sql = "SELECT " +
                 "SUM(CASE WHEN estado = 'En Proceso' THEN 1 ELSE 0 END) AS en_proceso, " +
                 "SUM(CASE WHEN estado = 'Completado' THEN 1 ELSE 0 END) AS completos, " +
                 "SUM(CASE WHEN estado = 'Retrasado' THEN 1 ELSE 0 END) AS retrasados " +
                 "FROM seguimientos_plazos";

    System.out.println("[DEBUG] Consulta SQL: " + sql); // Para depuración

    try (Connection cn = MySQLConexion.getConexion();
         PreparedStatement st = cn.prepareStatement(sql);
         ResultSet rs = st.executeQuery()) {

        if (rs.next()) {
            contadores.put("enProceso", rs.getInt("en_proceso"));
            contadores.put("completos", rs.getInt("completos"));
            contadores.put("retrasados", rs.getInt("retrasados"));
            
            System.out.println("[DEBUG] Resultados - " + contadores); // Log de resultados
        }
    } catch (Exception ex) {
        System.err.println("[ERROR] Error en contarPlazosPorEtapas: ");
        ex.printStackTrace();
    }
    return contadores;
}
    
    

}