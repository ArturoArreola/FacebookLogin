package demo

import static org.springframework.http.HttpStatus.*
import grails.converters.JSON
import grails.transaction.Transactional


@Transactional(readOnly = true)
class AgendaController 
{
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) 
    {
        params.max = Math.min(max ?: 10, 100)
        respond Agenda.list(params), model:[agendaCount: Agenda.count(), agenda: new Agenda()]
    }
    
    def reporte()
    {
        render( filename:"reporte.pdf",
                view:"reporteCita",
                marginLeft:15,
                marginTop:5,
                marginBottom:5,
                marginRight:15,
                headerSpacing:10,
                orientation: "landscape"
                
              ) 
    }
    
    
    def show(Agenda agenda) 
    {
        respond agenda
    }

    def datos ()
    {
        def list = Agenda.list()
        def userJson = JSON.parse(list)
        println "hola"
        render  list as JSON
    }
    
    def create() 
    {
        respond new Agenda(params)   
    }
    
    def notifierService 
    
    def send ()
    {   
        println "-------------------params.responsable: " + params.responsable
        println "-------------------params.agenda: " + params.agendayyyyyyy
        def usuario = Responsable.get(params.responsable as long)
        def datosCita = Agenda.get(params.agendayyyyyyy as long)
        notifierService.tareaAsignada(usuario, datosCita)
        redirect action: 'index'
    }   
    
    @Transactional
    def save(Agenda agenda, Agenda clonar, Responsable responsable) 
    {
        if (agenda == null) 
        {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        if (agenda.hasErrors()) 
        {
            transactionStatus.setRollbackOnly()
            respond agenda.errors, view:'create'
            return
        }
        agenda.inicio_cita = new Date()             //Asigna fecha actual al registro
        agenda.fin_cita = new Date()                //Asigna fecha actual al registro
        agenda.cambio_cita = false 
        agenda.numero_cita = 1
        
        agenda.save flush:true
        request.withFormat 
        {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'agenda.label', default: 'Agenda'), agenda.id])
                redirect(controller:"agenda", action: "send", params: [agendayyyyyyy: agenda.id, responsable:responsable.id])
            }
            '*' {redirect action:'send'}
        }
    }
    
    def edit(Agenda agenda) {
        respond agenda
    }

    @Transactional
    def update(Agenda agenda) {
        if (agenda == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (agenda.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond agenda.errors, view:'edit'
            return
        }
        
        agenda.cambio_cita = true
        
        agenda.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'agenda.label', default: 'Agenda'), agenda.id])
                redirect agenda
            }
            '*'{ respond agenda, [status: OK] }
        }
    }

    @Transactional
    def delete(Agenda agenda) {

        if (agenda == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        agenda.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'agenda.label', default: 'Agenda'), agenda.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'agenda.label', default: 'Agenda'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}