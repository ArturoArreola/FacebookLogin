package demo

import grails.plugin.mail.*;
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.Locale;
import groovy.time.TimeDuration
import groovy.time.TimeCategory
import demo.Agenda
import demo.Responsable
    
class NotifierService 
{
    def mailService

    def tareaAsignada(Responsable responsable, Agenda agenda) 
    {
        SimpleDateFormat formateador = new SimpleDateFormat("dd 'de' MMMM 'del' yyyy", new Locale("es","ES"));
        String fechaInicio = formateador.format(agenda.inicio_cita);
        String fechaFin = formateador.format(agenda.fin_cita);
        
        DateFormat horaInicio = DateFormat.getTimeInstance(DateFormat.SHORT);
        DateFormat horaFin = DateFormat.getTimeInstance(DateFormat.SHORT);
        
        horaInicio.format(agenda.inicio_cita)
        horaInicio.format(agenda.fin_cita)
        
        def correo = responsable.email
        def nombre = responsable.nombre
        def apellido = responsable.apellido
        
        def lugar = agenda.lugar
        def inicio = agenda.inicio_cita
        def fin = agenda.fin_cita.format("dd-MMM-yy")
        def asunto = agenda.titulo
        def descripcion = agenda.descripcion
        def bandera = agenda.todo_el_dia
        
        if(bandera == false)
        {
            mailService.sendMail 
            {
                to correo
                subject "Cita Infonavit: " + asunto
                body "Sr(a)" + nombre + " " + apellido + " se le recuerda que su cita es en " + lugar + " la cual inicia el día " + fechaInicio +  " y finaliza el " + fechaFin + " la cual va a servir para tratar temas de: " + descripcion
            }
        }
        else 
        {
            mailService.sendMail 
            {
                to correo
                subject "Cita Infonavit: " + asunto
                body "Sr(a)" + nombre + " " + apellido + " se le recuerda que su cita es en " + lugar + " la cual va a ser el día " + fechaInicio
            }
        }
    }
    
    def tareaCorreo() 
    {
        def mailService
        
        println"--------------------------llego"
        mailService.sendMail
        {     
            to "r2r.1310@gmail.com"     
            subject "Hello Fred"     
            body 'How are you?' 
        }
    }
}