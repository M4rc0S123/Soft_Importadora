/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package miServlet;

import controller.DevolucionControl;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import controller.ImportaControl;
import controller.SeguimientoControl;
import java.util.stream.Collectors;
import model.Importacion;

@WebServlet("/DashboardServlet1")
public class DashboardServlet1 extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Conteos para Importaciones
        ImportaControl importControl = new ImportaControl();
        request.setAttribute("totalPendientes", importControl.contarImportacionesPorEstado("pendiente"));
        request.setAttribute("totalEnTransito", importControl.contarImportacionesPorEstado("en_transito"));
        request.setAttribute("totalRecibidas", importControl.contarImportacionesPorEstado("recibido"));
        
        // Conteos para Devoluciones
        DevolucionControl devControl = new DevolucionControl();
        request.setAttribute("devolucionesPendientes", devControl.contarDevolucionesPorEstado("pendiente_envio"));
        request.setAttribute("devolucionesEnviadas", devControl.contarDevolucionesPorEstado("enviado"));
        request.setAttribute("devolucionesConfirmadas", devControl.contarDevolucionesPorEstado("confirmado"));
        
        // 2. Obtener importaciones para análisis de alertas
        List<Importacion> todasImportaciones = importControl.obtenerTodasLasImportaciones();
        
        // 3. Calcular retrasos y alertas
        long contadorRetrasados = todasImportaciones.stream()
            .filter(Importacion::estaRetrasada)
            .count();
        
        long contadorPorVencer = todasImportaciones.stream()
            .filter(Importacion::estaPorVencer)
            .count();
        
        List<String> alertas = todasImportaciones.stream()
            .filter(imp -> imp.estaRetrasada() || imp.estaPorVencer() || 
                          "cancelado".equalsIgnoreCase(imp.getEstado()) || 
                          "recibido".equalsIgnoreCase(imp.getEstado()))
            .sorted((a, b) -> {
                // Ordenar por prioridad: canceladas primero, luego retrasadas, luego por vencer
                if ("cancelado".equalsIgnoreCase(a.getEstado())) return -1;
                if ("cancelado".equalsIgnoreCase(b.getEstado())) return 1;
                if (a.estaRetrasada() && !b.estaRetrasada()) return -1;
                if (!a.estaRetrasada() && b.estaRetrasada()) return 1;
                if (a.estaPorVencer() && !b.estaPorVencer()) return -1;
                if (!a.estaPorVencer() && b.estaPorVencer()) return 1;
                return 0;
            })
            .map(imp -> imp.obtenerIconoAlerta() + " " + imp.obtenerMensajeAlerta())
            .limit(5) // Mostrar solo las 5 más urgentes
            .collect(Collectors.toList());
        
        // 4. Pasar atributos a la vista
        request.setAttribute("contadorRetrasados", contadorRetrasados);
        request.setAttribute("contadorPorVencer", contadorPorVencer);
        request.setAttribute("alertas", alertas);
        
        // 5. Importaciones recientes (últimas 5)
        List<Importacion> importacionesRecientes1 = todasImportaciones.stream()
            .sorted((a, b) -> b.getFecha_emision().compareTo(a.getFecha_emision()))
            .limit(5)
            .collect(Collectors.toList());
        
        request.setAttribute("importacionesRecientes", importacionesRecientes1);
        


        // 3. Nuevo: Seguimiento de Plazos (usando SeguimientoControl)
        SeguimientoControl segControl = new SeguimientoControl();
        Map<String, Integer> seguimiento = segControl.contarPlazosPorEtapas(); // Método a implementar (paso 2)
        
        request.setAttribute("contadorEnProceso", seguimiento.get("enProceso"));
        request.setAttribute("contadorCompletos", seguimiento.get("completos"));
        request.setAttribute("contadorRetrasados", seguimiento.get("retrasados"));
        
        // 2. Obtener importaciones recientes
        List<Map<String, Object>> importacionesRecientes = importControl.listarImportacionesCompletas();
        request.setAttribute("importacionesRecientes", importacionesRecientes);
        
        System.out.println("Importaciones recientes encontradas: " + importacionesRecientes.size()); // Log
        
        // 3. Verificar si hay datos
        if (importacionesRecientes.isEmpty()) {
            System.out.println("No se encontraron importaciones recientes"); // Log
        } else {
            System.out.println("Primera importación: " + importacionesRecientes.get(0)); // Log
        }
        
        List<Importacion> importacionesConAlerta = todasImportaciones.stream()
    .filter(imp -> 
        ("cancelado".equalsIgnoreCase(imp.getEstado())) ||  // Canceladas siempre muestran alerta
        (imp.getFecha_real_arribo() == null &&              // Solo si no hay fecha real
         (imp.estaRetrasada() || imp.estaPorVencer())) ||   // Y está retrasada o por vencer
        "recibido".equalsIgnoreCase(imp.getEstado())        // Recepciones completas
    )
    .sorted((a, b) -> {
        // Ordenar por prioridad
        boolean aCancelada = "cancelado".equalsIgnoreCase(a.getEstado());
        boolean bCancelada = "cancelado".equalsIgnoreCase(b.getEstado());
        
        if (aCancelada && !bCancelada) return -1;
        if (!aCancelada && bCancelada) return 1;
        
        if (a.estaRetrasada() && !b.estaRetrasada()) return -1;
        if (!a.estaRetrasada() && b.estaRetrasada()) return 1;
        
        if (a.estaPorVencer() && !b.estaPorVencer()) return -1;
        if (!a.estaPorVencer() && b.estaPorVencer()) return 1;
        
        return 0;
    })
    .collect(Collectors.toList());
        
        request.getRequestDispatcher("principal1.jsp").forward(request, response);
    }
    
}