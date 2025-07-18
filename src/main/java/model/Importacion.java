
package model;

import java.util.Date;


public class Importacion {
    int id_importacion;
    String codigo_importacion;
    Date fecha_emision;
    Date fecha_estimada_arribo;
    Date fecha_real_arribo;
    String estado;
    int id_proveedor;
    int responsable;

    public int getId_importacion() {
        return id_importacion;
    }

    public void setId_importacion(int id_importacion) {
        this.id_importacion = id_importacion;
    }

    public String getCodigo_importacion() {
        return codigo_importacion;
    }

    public void setCodigo_importacion(String codigo_importacion) {
        this.codigo_importacion = codigo_importacion;
    }

    public Date getFecha_emision() {
        return fecha_emision;
    }

    public void setFecha_emision(Date fecha_emision) {
        this.fecha_emision = fecha_emision;
    }

    public Date getFecha_estimada_arribo() {
        return fecha_estimada_arribo;
    }

    public void setFecha_estimada_arribo(Date fecha_estimada_arribo) {
        this.fecha_estimada_arribo = fecha_estimada_arribo;
    }

    public Date getFecha_real_arribo() {
        return fecha_real_arribo;
    }

    public void setFecha_real_arribo(Date fecha_real_arribo) {
        this.fecha_real_arribo = fecha_real_arribo;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public int getId_proveedor() {
        return id_proveedor;
    }

    public void setId_proveedor(int id_proveedor) {
        this.id_proveedor = id_proveedor;
    }

    public int getResponsable() {
        return responsable;
    }

    public void setResponsable(int responsable) {
        this.responsable = responsable;
    }
    public boolean estaRetrasada() {
        if (!"recibido".equalsIgnoreCase(this.estado) && 
        !"cancelado".equalsIgnoreCase(this.estado) && 
        this.fecha_estimada_arribo != null &&
        this.fecha_real_arribo == null) {  // Cambio clave aquí
        
        Date hoy = new Date();
        return hoy.after(this.fecha_estimada_arribo);
    }
    return false;
}
    
    public boolean estaPorVencer() {
        if (!"recibido".equalsIgnoreCase(this.estado) && 
            !"cancelado".equalsIgnoreCase(this.estado) && 
            this.fecha_estimada_arribo != null &&
            this.fecha_real_arribo == null) {
            
            Date hoy = new Date();
            long diff = this.fecha_estimada_arribo.getTime() - hoy.getTime();
            long diasRestantes = diff / (1000 * 60 * 60 * 24);
            return diasRestantes <= 2; // Alerta si faltan 2 días o menos
        }
        return false;
    }
    
    public String obtenerIconoAlerta() {
        if ("cancelado".equalsIgnoreCase(this.estado)) {
            return "❌";
        } else if (estaRetrasada()) {
            return "📌";
        } else if (estaPorVencer()) {
            return "⏰";
        } else if ("recibido".equalsIgnoreCase(this.estado)) {
            return "✔";
        }
        return "";
    }
    
    public String obtenerMensajeAlerta() {
        String codigo = this.codigo_importacion != null ? this.codigo_importacion : "IMP-XXXXXX";
        
        if ("cancelado".equalsIgnoreCase(this.estado)) {
            return "Cancelada " + codigo;
        } else if (estaRetrasada()) {
            return "Retraso en " + codigo;
        } else if (estaPorVencer()) {
            return "Vencimiento próximo en " + codigo;
        } else if ("recibido".equalsIgnoreCase(this.estado)) {
            return "Confirmación de recepción: " + codigo;
        }
        return "";
    }
}

   
