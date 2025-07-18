/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.TipoSeguimiento;
import util.MySQLConexion;

/**
 *
 * @author MICHO
 */
public class TipoSeguimientoControl {
   
    public List<TipoSeguimiento> listarTodos() {
        List<TipoSeguimiento> lista = new ArrayList<>();

        String sql = "SELECT id_tipo_seguimiento, nombre FROM tipos_seguimiento";

           try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                TipoSeguimiento ts = new TipoSeguimiento();
                ts.setId(rs.getInt("id_tipo_seguimiento"));
                ts.setNombre(rs.getString("nombre"));
                lista.add(ts);
            }

        } catch (SQLException e) {
        }

        return lista;
    }
} 

