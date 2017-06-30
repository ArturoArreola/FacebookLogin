package demo

import groovy.time.TimeDuration
import java.text.SimpleDateFormat
import demo.NotifierService

class EnviaCorreosJob 
{
    Integer diasParaCorreo = 3
    NotifierService notificar = new NotifierService()
    SimpleDateFormat formateador = new SimpleDateFormat("dd 'de' MMMM 'del' yyyy", new Locale("es","ES"));
    
    def mailService
    
    static triggers = 
    {
        cron name: 'myTrigger', cronExpression: "*/59 * * * * ?"
    }
    def group = "MyGroup"
    def description = "Example job with Cron Trigger"
    def fechaHoy = new Date()
    
    def execute()
    {   
//        println "------------------ Corriendo cada 5 segundos -------------------"
        def queryAgenda = Agenda.where 
        {
            (inicio_cita <= (fechaHoy + diasParaCorreo) ) && (inicio_cita >= fechaHoy) && (cambio_cita == false)
        }
        def listaAgenda = queryAgenda.list()
//       println "----------------------Lista de las fechas : " + listaAgenda
        def correoDelegado = Responsable.findByNombre("Delegado")
        def correoGerente = Responsable.findByNombre("Gerente")
        def correoSubdirector = Responsable.findByNombre("Subdirector")
        def correoDirector = Responsable.findByNombre("Director")
//        def queryFechas = FechasCitas.executeQuery("select f from " + FechasCitas.class.getName() + " f")
//        listaAgenda.each                          DE AQUI HASTA LA 142
//        {
//            agenda ->
//            
//            String agendaFechaInicio = formateador.format(agenda.inicio_cita);
//            String agendaFechaFin = formateador.format(agenda.fin_cita);
//            
//            
////            println "------------esto es agenda: " + agenda.id
////            println "------------esto es responsable: " + agenda.responsable.apellido
//            println "---------------------Dentro de la lista ------------------------"
//            println "---------------------Agenda-------------------------" + agenda
//            
//            def queryCitas = FechasCitas.findWhere(cita_nueva:agenda)
//                 
//            queryCitas.each
//            {
//                citas ->
//                
//                String citaFechaInicio = formateador.format(citas.cita_original.inicio_cita);
//                String citaFechaFin = formateador.format(citas.cita_original.fin_cita);
//                println "---------------------Dentro de queryCitas-------------------------" + citas
//
//                def queryCitasNuevas = FechasCitas.findAllByCita_nueva(citas.cita_original)
////     comentada           def listaCitasNuevas = queryCitasNuevas.list()
//
//                queryCitasNuevas.each
//                {
//                    citaNueva ->
//
//                    String citaNuevaFechaInicio = formateador.format(citaNueva.cita_original.inicio_cita);
//                    String citaNuevaFechaFin = formateador.format(citaNueva.cita_original.fin_cita);
//                    println "---------------------Dentro de listaCitasNuevas-------------------------" + citaNueva
//                    println"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
//
////    comentada                mailService.sendMail
////    comentada                {
////    comentada                    to agenda.responsable.email
////    comentada                    subject "Cita infonavit: " + agenda.titulo
////    comentada                    body "Sr(a). " + agenda.responsable.nombre + " " + agenda.responsable.apellido + " se le informa que dentro de " + diasParaCorreo + " días va a ser su cita en " + agenda.lugar + " \n Va a ser el día " + agendaFechaInicio + " y va a culminar el " + agendaFechaFin + \
////    comentada                         "\n Los cambios que se han hecho son los siguientes:" + \
////    comentada                         "\n " + citaNuevaFechaInicio + " \t " + citaNuevaFechaFin + " \n" +\
////    comentada                         " " + citaFechaInicio + " \t " + citaFechaFin 
////    comentada                } 
////    comentada                def citasOriginales = FechasCitas.findAllByCita_nueva(citaNueva)
////    comentada                def listaCitasOriginales = queryCitasOriginales.list()
//                }
//                
//            }
//            
//            println "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
//            
////            if(agenda.numero_cita < 3)
////            {
////               mailService.sendMail
////                {
////                    to agenda.responsable.email
////                    subject "Cita infonavit: " + agenda.titulo
////                    body "Sr(a). " + agenda.responsable.nombre + " " + agenda.responsable.apellido + " se le informa que dentro de " + diasParaCorreo + " días va a ser su cita en " + agenda.lugar + " \n Va a ser el día " + fechaInicio + " y va a culminar el " + fechaFin + "\n Los cambios que se han hecho son los siguientes: " citaDiferida.cita_nueva
////                } 
////            }
////            else if (agenda.numero_cita >= 3 && agenda.numero_cita < 6)
////            {
////                mailService.sendMail
////                {
////                    to agenda.responsable.email
////                    from "arturo.arreola.1310@gmail.com"
////                    cc correoDelegado.email
////                    subject "Cita infonavit: " + agenda.titulo
////                    body "Sr(a). " + agenda.responsable.nombre + " " + agenda.responsable.apellido + " se le informa que dentro de " + diasParaCorreo + " días va a ser su cita en " + agenda.lugar + " \nVa a ser el día " + fechaInicio + " y va a culminar el " + fechaFin + " \nEstá cita se ha cambiado " + agenda.numero_cita-1 + " veces de fecha."
////                }
////            }
////            else if (agenda.numero_cita >= 6 && agenda.numero_cita < 9)
////            {
////                mailService.sendMail
////                {
////                    to agenda.responsable.email
////                    from "arturo.arreola.1310@gmail.com"
////                    cc correoGerente.email
////                    subject "Cita infonavit: " + agenda.titulo
////                    body "Sr(a). " + agenda.responsable.nombre + " " + agenda.responsable.apellido + " se le informa que dentro de " + diasParaCorreo + " días va a ser su cita en " + agenda.lugar + " \nVa a ser el día " + fechaInicio + " y va a culminar el " + fechaFin + " \nEstá cita se ha cambiado " + agenda.numero_cita-1 + " veces de fecha."
////                }
////            }
////            else if (agenda.numero_cita >= 9 && agenda.numero_cita < 12)
////            {
////                mailService.sendMail
////                {
////                    to agenda.responsable.email
////                    from "arturo.arreola.1310@gmail.com"
////                    cc correoSubdirector.email
////                    subject "Cita infonavit: " + agenda.titulo
////                    body "Sr(a). " + agenda.responsable.nombre + " " + agenda.responsable.apellido + " se le informa que dentro de " + diasParaCorreo + " días va a ser su cita en " + agenda.lugar + " \nVa a ser el día " + fechaInicio + " y va a culminar el " + fechaFin + " \nEstá cita se ha cambiado " + agenda.numero_cita-1 + " veces de fecha."
////                }
////            }
////            else if (agenda.numero_cita >= 12 && agenda.numero_cita < 15)
////            {
////                mailService.sendMail
////                {
////                    to agenda.responsable.email
////                    from "arturo.arreola.1310@gmail.com"
////                    cc correoSubdirector.email
////                    subject "Cita infonavit: " + agenda.titulo
////                    body "Sr(a). " + agenda.responsable.nombre + " " + agenda.responsable.apellido + " se le informa que dentro de " + diasParaCorreo + " días va a ser su cita en " + agenda.lugar + " \nVa a ser el día " + fechaInicio + " y va a culminar el " + fechaFin + " \nEstá cita se ha cambiado " + agenda.numero_cita-1 + " veces de fecha."
////                }
////            }
//        }
    }
}   





















