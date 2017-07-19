package mx.gox.infonavit.sicj.admin

import grails.transaction.Transactional
import grails.plugins.csv.CSVWriter
import mx.gox.infonavit.sicj.auditoria.BitacoraDeAcceso
import mx.gox.infonavit.sicj.auditoria.BitacoraDeUsuario
import mx.gox.infonavit.sicj.auditoria.BitacoraDeJuicio
import mx.gox.infonavit.sicj.juicios.Juicio
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

@Transactional
class UserService {
    
    private static final Logger log = LogManager.getLogger(UserService)

    def obtenerPerfilesPorUsuario() {
        def listaDeUsuarios = []
        def usuariosPerfiles =  UsuarioPerfil.list()
        usuariosPerfiles = usuariosPerfiles.groupBy{ it.usuario }
        log.info usuariosPerfiles
        usuariosPerfiles.each { key, value->
            def mapa = [:]
            mapa.usuario = key
            mapa.perfiles = value*.perfil
            listaDeUsuarios << mapa
        }
        log.info listaDeUsuarios
        [perfiles:Perfil.list(), listaDeUsuarios: listaDeUsuarios]
    }
    
    def generarReporteGeneral(){
        def contenidoReporte = obtenerPerfilesPorUsuario()
        if(contenidoReporte) {
            def sw = new StringWriter()
            def b
            def x = 3
            b = new CSVWriter(sw, {
                    col1: "Usuario" { it.val1 }
                    col2: "Delegacion" { it.val2 }
                    col3: "Despacho/Proveedor" { it.val3 }
                    contenidoReporte.perfiles.each{ perfil ->
                        x++
                        def nombreColumna = "col$x"
                        log.info ("Columna: " + nombreColumna + " - Variable: " + "val$x")
                        nombreColumna: "$perfil.name" { it."val$x" }
                    }
                })
            contenidoReporte.listaDeUsuarios.each { usuarioPerfil ->
                def valores = [:]
                x = 3
                valores.val1 = usuarioPerfil.usuario.toString()
                valores.val2 = usuarioPerfil.usuario.delegacion.nombre
                valores.val3 = ((usuarioPerfil.usuario.despacho ?: usuarioPerfil.usuario.proveedor) ?: "")
                contenidoReporte.perfiles.each{ perfil ->
                    x++
                    valores."val$x" = (usuarioPerfil.perfiles.contains(perfil) ? "X" : "")
                }
                log.info valores
                b << valores
            }
            def archivoReporte = new File("reporteGenerado.csv")
            archivoReporte.withWriter('UTF-8') { writer ->
                writer.write(b?.writer?.toString())
            }
            return archivoReporte
        }
    }
    
    def obtenerUltimosMovimientosPorUsuario(def usuario, def fechaInicial, def fechaFinal){
        def respuesta = [:]
        //respuesta.ultimosAccesos = BitacoraDeAcceso.executeQuery("Select ba from BitacoraDeAcceso ba Where ba.username = :username AND ba.fechaDeEvento between to_timestamp('" + fechaInicial + " 00:00','dd/mm/yyyy hh24:mi') and to_timestamp('" + fechaFinal + " 23:59','dd/mm/yyyy hh24:mi') Order by ba.fechaDeEvento desc",[username: usuario.username])
        respuesta.ultimosAccesos = BitacoraDeAcceso.executeQuery("Select ba from BitacoraDeAcceso ba Where ba.username = :username AND ba.fechaDeEvento between convert(datetime, '" + fechaInicial + " 00:00',103) and convert(datetime, '" + fechaFinal + " 23:59',103)  Order by ba.fechaDeEvento",[username: usuario.username])
        //def cambiosDeStatus = BitacoraDeJuicio.executeQuery("Select bj from BitacoraDeJuicio bj Where bj.usuario.id = :idUsuario AND bj.fechaDeMovimiento between to_timestamp('" + fechaInicial + " 00:00','dd/mm/yyyy hh24:mi') and to_timestamp('" + fechaFinal + " 23:59','dd/mm/yyyy hh24:mi') Order by bj.fechaDeMovimiento",[idUsuario: usuario.id])
        def cambiosDeStatus = BitacoraDeJuicio.executeQuery("Select bj from BitacoraDeJuicio bj Where bj.usuario.id = :idUsuario AND bj.fechaDeMovimiento between convert(datetime, '" + fechaInicial + " 00:00',103) and convert(datetime, '" + fechaFinal + " 23:59',103) Order by bj.fechaDeMovimiento",[idUsuario: usuario.id])
        //def cambiosGenerales = Juicio.executeQuery("Select j from Juicio j Where j.personaQueModifico.id = :idUsuario AND j.ultimaModificacion between to_timestamp('" + fechaInicial + " 00:00','dd/mm/yyyy hh24:mi') and to_timestamp('" + fechaFinal + " 23:59','dd/mm/yyyy hh24:mi') Order by j.ultimaModificacion",[idUsuario: usuario.id])
        def cambiosGenerales = Juicio.executeQuery("Select j from Juicio j Where j.personaQueModifico.id = :idUsuario AND j.ultimaModificacion between convert(datetime, '" + fechaInicial + " 00:00',103) and convert(datetime, '" + fechaFinal + " 23:59',103) Order by j.ultimaModificacion",[idUsuario: usuario.id])
        respuesta.ultimosMovimientos = []
        cambiosDeStatus.each {
            def mapa = [:]
            mapa.usuario = usuario
            mapa.descripcion = "Cambio de estado del juicio"
            mapa.fecha = it.fechaDeMovimiento
            mapa.juicio = it.juicio
            respuesta.ultimosMovimientos  << mapa
        }
        cambiosGenerales.each {
            def mapa = [:]
            mapa.usuario = usuario
            mapa.descripcion = "Actualización General (Avance de Workflow, Edición, etc...)"
            mapa.fecha = it.ultimaModificacion
            mapa.juicio = it
            respuesta.ultimosMovimientos  << mapa
        }
        respuesta.ultimosMovimientos = respuesta.ultimosMovimientos?.sort{ it.fecha }
        respuesta.ultimosMovimientos = respuesta.ultimosMovimientos?.reverse()
        respuesta
    }
}
