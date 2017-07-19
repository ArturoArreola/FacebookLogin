package mx.gox.infonavit.sicj.juicios

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.converters.JSON
import mx.gox.infonavit.sicj.admin.Delegacion
import mx.gox.infonavit.sicj.admin.Despacho
import mx.gox.infonavit.sicj.admin.Region
import mx.gox.infonavit.sicj.admin.Usuario
import mx.gox.infonavit.sicj.auditoria.BitacoraDeJuicio
import mx.gox.infonavit.sicj.auditoria.BitacoraDeWorkFlow
import mx.gox.infonavit.sicj.catalogos.Materia
import mx.gox.infonavit.sicj.catalogos.Municipio
import mx.gox.infonavit.sicj.catalogos.Estado
import mx.gox.infonavit.sicj.catalogos.Ambito
import mx.gox.infonavit.sicj.catalogos.Autoridad
import mx.gox.infonavit.sicj.catalogos.AutoridadMunicipio
import mx.gox.infonavit.sicj.catalogos.Delito
import mx.gox.infonavit.sicj.catalogos.Persona
import mx.gox.infonavit.sicj.catalogos.PrestacionReclamada
import mx.gox.infonavit.sicj.catalogos.TipoAsociado
import mx.gox.infonavit.sicj.catalogos.TipoDeAsignacion
import mx.gox.infonavit.sicj.catalogos.TipoDeAutoridad
import mx.gox.infonavit.sicj.catalogos.EstadoDeProcesoAlterno
import mx.gox.infonavit.sicj.catalogos.TipoDeProcesoAlterno
import mx.gox.infonavit.sicj.catalogos.TipoDeProcedimiento
import mx.gox.infonavit.sicj.catalogos.TipoDeProcedimientoAmbito
import mx.gox.infonavit.sicj.catalogos.TipoDeParteProcedimiento
import mx.gox.infonavit.sicj.catalogos.TipoDeReproceso
import mx.gox.infonavit.sicj.catalogos.RespuestaPregunta
import mx.gox.infonavit.sicj.catalogos.PreguntaEtapaProcesal
import mx.gox.infonavit.sicj.catalogos.Ambito
import mx.gox.infonavit.sicj.catalogos.Autoridad
import mx.gox.infonavit.sicj.catalogos.EstadoDeJuicio
import mx.gox.infonavit.sicj.catalogos.EtapaProcesal
import mx.gox.infonavit.sicj.catalogos.EtapaProcesalTipoDeParte
import mx.gox.infonavit.sicj.catalogos.PatrocinadorDelJuicio
import mx.gox.infonavit.sicj.catalogos.Provision
import mx.gox.infonavit.sicj.catalogos.MotivoDeTermino
import mx.gox.infonavit.sicj.catalogos.FormaDePago
import mx.gox.infonavit.sicj.catalogos.FlujoEtapaProcesal
import mx.gox.infonavit.sicj.catalogos.TipoDeParte
import mx.gox.infonavit.sicj.catalogos.MotivoDeTerminoMateria
import mx.gox.infonavit.sicj.juicios.CreditoJuicio
import mx.gox.infonavit.sicj.juicios.UbicacionDelInmuebleJuicio
import mx.gox.infonavit.sicj.juicios.NotificacionJuicio
import mx.gox.infonavit.sicj.juicios.DelitoJuicio
import mx.gox.infonavit.sicj.juicios.TipoAsociadoJuicio
import mx.gox.infonavit.sicj.juicios.ActorJuicio
import mx.gox.infonavit.sicj.juicios.UsuarioJuicio
import mx.gox.infonavit.sicj.juicios.NotaJuicio
import mx.gox.infonavit.sicj.juicios.ControlJuicio
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

@Transactional(readOnly = true)
class JuicioController {

    private static final Logger log = LogManager.getLogger(JuicioController)
    
    static allowedMethods = [save: "POST", update: "POST", delete: "DELETE"]
    def springSecurityService
    def juicioService
    def audienciaJuicioService
    
    def index(Integer max) {
        redirect(action: "search")
    }

    def show(Juicio juicio) {
        log.info "-- params show: " + params
        if(juicio){
            def controlJuicio = ControlJuicio.findWhere(juicio: juicio)
            def responsableDelDespacho = (juicio.responsableDelDespacho ?: Usuario.findWhere(despacho: juicio?.despacho, responsableDelDespacho: true, enabled: true))
            def gerenteJuridico = (juicio.gerenteJuridico ?: Usuario.findWhere(delegacion: juicio?.delegacion, gerenteJuridico: true, enabled: true))
            def numerosDeCredito = (CreditoJuicio.findAllWhere(juicio: juicio))*.numeroDeCredito
            def delitosJuicio = (DelitoJuicio.findAllWhere(juicio: juicio))*.delito
            def tiposAsociadosJuicio = (TipoAsociadoJuicio.findAllWhere(juicio: juicio))*.tipoAsociado
            def notificacionJuicio = NotificacionJuicio.findAllWhere(juicio:juicio)
            notificacionJuicio = notificacionJuicio.sort{it.id}
            log.info("LISTA NOTIFICACION JUICIO: " + notificacionJuicio)
            def ubicacionDelInmueble = UbicacionDelInmuebleJuicio.findWhere(juicio: juicio)
            def actores = ActorJuicio.findAllWhere(juicio: juicio)
            def usuarios = UsuarioJuicio.findAllWhere(juicio: juicio)
            def prestacionReclamada = ((juicio.materia.id == 1 || juicio.materia.id == 2) ? (tiposAsociadosJuicio*.prestacionReclamada as Set) : (delitosJuicio*.tipoDeAsignacion as Set))
            def etapasProcesales = EtapaProcesal.obtenerEtapas(juicio.tipoDeProcedimiento.id, juicio.tipoDeParte.id)
            def acuerdos = AcuerdoJuicio.findAllWhere(juicio: juicio)
            def promociones = PromocionJuicio.findAllWhere(juicio: juicio)
            def archivos = ArchivoJuicio.findAllWhere(juicio: juicio)
            def procesoAlterno = ProcesoAlternoJuicio.findWhere(juicio:juicio, estadoDeProceso: EstadoDeProcesoAlterno.get(1))
            def procesosAlternos = ProcesoAlternoJuicio.findWhere(juicio:juicio)
            def pagosDeRezago = PagoJuicioRezago.findAllWhere(juicio:juicio)
            pagosDeRezago = pagosDeRezago.sort{ it.numeroDePago }
            log.info("LISTA PAGOS: " + pagosDeRezago)
            def colores = juicioService.obtenerColorPorEtapa(juicio)
            def autoridadesProcesoAlterno = AutoridadMunicipio.executeQuery("select am.autoridad from AutoridadMunicipio am where am.municipio.estado.id = ? and am.autoridad.materia.id = ? order by am.autoridad.nombre" , [juicio.delegacion.estado.id, juicio.materia.id])
            autoridadesProcesoAlterno = autoridadesProcesoAlterno as Set
            etapasProcesales = etapasProcesales.sort { it.numeroSecuencial }
            log.info etapasProcesales
            respond juicio, model: [colores: colores, pagosDeRezago: pagosDeRezago, pagosRegistrados: pagosDeRezago?.size(), notificacionJuicio: notificacionJuicio, notificacionJuicioCantidad: notificacionJuicio?.size(), autoridadesProcesoAlterno: autoridadesProcesoAlterno, procesoAlterno: procesoAlterno, controlJuicio: controlJuicio, procesosAlternos:procesosAlternos, responsableDelDespacho: responsableDelDespacho, gerenteJuridico: gerenteJuridico, numerosDeCredito: numerosDeCredito, delitosJuicio: delitosJuicio, tiposAsociadosJuicio: tiposAsociadosJuicio, ubicacionDelInmueble: ubicacionDelInmueble, actores: actores, prestacionReclamada: prestacionReclamada, etapasProcesales: etapasProcesales, acuerdos: acuerdos, promociones: promociones, archivos: archivos]
        }
    }

    def create() {
        log.info params
        def materia
        if(params?.materia.equals('laboral')) {
            materia = Materia.get(1)
        } else if(params?.materia.equals('civil')) {
            materia = Materia.get(2)
        } else if(params?.materia.equals('penal')){
            materia = Materia.get(3)
        } else if(params?.materia.equals('rezago')){
            materia = Materia.get(4)
        }
        if(session.listaDeActores){
            log.info("Eliminando contenido de la lista de actores")
            session.listaDeActores = null
        }
        if(session.listaDeDemandados){
            log.info("Eliminando contenido de la lista de demandados")
            session.listaDeDemandados = null
        }
        if(session.listaDeTerceros){
            log.info("Eliminando contenido de la lista de terceros")
            session.listaDeTerceros = null
        }
        if(session.listaDeDenunciantes){
            log.info("Eliminando contenido de la lista de denunciantes")
            session.listaDeDenunciantes = null
        }
        if(session.listaDeResponsables){
            log.info("Eliminando contenido de la lista de responsables")
            session.listaDeResponsables = null
        }
        //respond new Juicio(params)
        [juicio: new Juicio(), materia: materia, usuario: springSecurityService.currentUser]
    }

    @Transactional
    def save() {
        log.info params
        def juicio = new Juicio()
        def numerosDeCredito
        def ubicacionDelInmuebleJuicio
        def notificacionJuicio = new NotificacionJuicio()
        def tiposAsociados
        def delitos
        def actor
        def existeFinado = []
        def listaFinados = []
        def existeExpedienteInterno
        def respuesta = [:]
        def mensajeDetallesFinado = []
        boolean banderaNotificacionFinado = false
        
        juicio.materia = Materia.get(params.materia as long)
        juicio.estadoDeJuicio = EstadoDeJuicio.get(1)
        juicio.delegacion = ((params.delegacion?.id && !params.delegacion?.id?.equals('')) ? Delegacion.get(params.delegacion.id as long) : null)
        juicio.despacho = ((params.despacho?.id && !params.despacho?.id?.equals('')) ? Despacho.get(params.despacho.id as long) : null)
        juicio.proveedor = ((params.proveedor?.id && !params.proveedor?.id?.equals('')) ? Proveedor.get(params.proveedor.id as long) : null)
        juicio.region = ((params.region?.id && !params.region?.id?.equals('')) ? Region.get(params.region.id as long) : null)
        juicio.ambito = ((params.ambito?.id && !params.ambito?.id?.equals('')) ? Ambito.get(params.ambito.id as long) : null)
        juicio.tipoDeProcedimiento = ((params.tipoDeProcedimiento?.id && !params.tipoDeProcedimiento?.id.equals('')) ? TipoDeProcedimiento.get(params.tipoDeProcedimiento.id as long) : null)
        juicio.tipoDeParte = ((!params.tipoDeParte?.id?.equals('')) ? TipoDeParte.get(params.tipoDeParte.id as long) : null)
        juicio.patrocinadoDelJuicio = ((params.patrocinadoDelJuicio?.id && !params.patrocinadoDelJuicio?.id?.equals('')) ? PatrocinadorDelJuicio.get(params.patrocinadoDelJuicio.id as long) : null)
        juicio.provision = ((params.provision?.id && !params.provision?.id?.equals('')) ? Provision.get(params.provision.id as long) : null)
        juicio.autoridad = ((params.autoridad?.id && !params.autoridad?.id?.equals('')) ? Autoridad.get(params.autoridad.id as long) : null)
        juicio.municipioAutoridad = ((params.municipioAutoridad?.id && !params.municipioAutoridad?.id?.equals('')) ? Municipio.get(params.municipioAutoridad.id as long) : null)
        juicio.creadorDelCaso = springSecurityService.currentUser
        juicio.expedienteInterno = params.expedienteInterno
        juicio.expediente = (params.expediente ? params.expediente : params.numeroDeAsignacion)
        juicio.antecedentes = params.antecedentes
        juicio.fechaRD = ((params.fechaRD) ? new Date().parse('dd/MM/yyyy',params.fechaRD) : null)
        juicio.finado = ((params.finado?.equals("SI")) ? true : false)
        juicio.subprocuraduria = params?.subprocuraduria
        juicio.unidadEspecializada = params?.unidadEspecializada
        juicio.fiscalia = params?.fiscalia
        juicio.mesaInvestigadora = params?.mesaInvestigadora
        juicio.agencia = params?.agencia
        juicio.numeroDeCausaPenal = params?.numeroDeCausaPenal
        juicio.otraInstancia = params?.otraInstancia
        juicio.acreditado = params?.acreditado
        juicio.anioDelCredito = params?.anioDelCredito
        juicio.notario = params?.notario
        juicio.responsableDelDespacho = Usuario.findWhere(despacho: juicio?.despacho, responsableDelDespacho: true, enabled: true)
        juicio.gerenteJuridico = Usuario.findWhere(delegacion: juicio?.delegacion, gerenteJuridico: true, enabled: true)

        juicio.radicacionDelJuicio = ((params.radicacionDelJuicio?.id && !params.radicacionDelJuicio?.id?.equals('')) ? Delegacion.get(params.radicacionDelJuicio.id as long) : null)
        
        if(juicio.expedienteInterno){
            log.info "EXP. INTERNO -> " + juicio.expedienteInterno
            log.info "DELEGACION -> " + juicio.delegacion
            existeExpedienteInterno = Juicio.find("From Juicio j Where j.expedienteInterno = :expedienteInterno", [expedienteInterno: juicio.expedienteInterno])
            log.info "RESULTADO EXP. INTERNO -> " + existeExpedienteInterno
        }
        if(existeExpedienteInterno){
            respuesta.exito = false
            respuesta.validacion = "Juicio Duplicado"
            respuesta.mensaje = juicioService.generarInfoJuicio([existeExpedienteInterno] as Juicio[])
        } 
        else {
            if(juicio.finado){
            juicio.nombreDelFinado = (params.nombreDelFinado?.trim())?.replaceAll("\\s+", " ")
            juicio.numeroSeguroSocialDelFinado = (params.numeroSeguroSocialDelFinado?.trim())?.replaceAll("\\s+", " ")
            juicio.rfcDelFinado = (params.rfcDelFinado)?.replaceAll("\\s+", " ")
            existeFinado = Juicio.find("From Juicio j Where (j.estadoDeJuicio.id in (1,2,5)) and (j.nombreDelFinado = :nombreDelFinado or j.numeroSeguroSocialDelFinado = :nssFinado)", [nombreDelFinado: juicio.nombreDelFinado, nssFinado: juicio.numeroSeguroSocialDelFinado])
            log.info "FINADO ->"+  existeFinado
            }
            if(existeFinado){
                respuesta.exito = false
                respuesta.validacion = "Finado Duplicado"
                respuesta.mensaje = juicioService.generarInfoJuicio([existeFinado] as Juicio[])
                listaFinados = Juicio.find("From Juicio j Where (j.estadoDeJuicio.id in (1,2,5)) and (j.nombreDelFinado = :nombreDelFinado or j.numeroSeguroSocialDelFinado = :nssFinado)", [nombreDelFinado: juicio.nombreDelFinado, nssFinado: juicio.numeroSeguroSocialDelFinado])
                mensajeDetallesFinado = juicioService.generarNotificacionJuicio([listaFinados] as Juicio[])
                log.info ("MENSAJE DETALLES FINADO: " + mensajeDetallesFinado)
                banderaNotificacionFinado = true
            } //else {
            juicio.cantidadDemandada = ((params.cantidadDemandada?.equals("SI") || params.danoPatrimonial?.equals("SI")) ? true : false)
            if(juicio.cantidadDemandada){
                if(params.monto) {
                    juicio.monto = params.monto as long
                } else {
                    juicio.monto = 0
                }
                //juicio.tipoDeMoneda = TipoDeMoneda.get(params.tipoDeMoneda.id as long)
            }
            if(params.numeroDeCredito){
                numerosDeCredito = (params.numeroDeCredito).tokenize(",")
            }
            if(params.ubicacionCalle || params.ubicacionEstado?.id || params.ubicacionMunicipio?.id || params.ubicacionNumeroExterior || params.ubicacionNumeroInterior || params.ubicacionColonia || params.ubicacionCP){
                ubicacionDelInmuebleJuicio = new UbicacionDelInmuebleJuicio()
                ubicacionDelInmuebleJuicio.calle = params.ubicacionCalle
                ubicacionDelInmuebleJuicio.estado = ((params.ubicacionEstado?.id && !params.ubicacionEstado?.id?.equals('')) ? Estado.get(params.ubicacionEstado.id as long) : null)
                ubicacionDelInmuebleJuicio.municipio = ((params.ubicacionMunicipio?.id && !params.ubicacionMunicipio?.id?.equals('')) ? Municipio.get(params.ubicacionMunicipio.id as long) : null)
                ubicacionDelInmuebleJuicio.colonia = params.ubicacionColonia
                ubicacionDelInmuebleJuicio.numeroExterior = params.ubicacionNumeroExterior
                ubicacionDelInmuebleJuicio.numeroInterior = params.ubicacionNumeroInterior
                ubicacionDelInmuebleJuicio.codigoPostal = params.ubicacionCP
            }
        
            if(juicio.despacho?.id < 0){
                juicio.responsableDelJuicio = Usuario.get(params.responsableDelJuicio.id as long)
            }
        
            if(juicio.materia.id == 1 || juicio.materia.id == 2){
                def paramsTiposAsociados = params.findAll{it.key.startsWith("TASOCIADO_")}
                def tipoAsociadoAgregado
                tiposAsociados = []
                paramsTiposAsociados.each{ key, value ->
                    if(value.equals('on')){
                        tipoAsociadoAgregado = TipoAsociado.get((key.minus('TASOCIADO_')) as long)
                        log.info tipoAsociadoAgregado?.nombre
                        if(tipoAsociadoAgregado?.nombre.equals("OTRO")){
                            log.info "si entra"
                            def nuevoTipoAsociado = new TipoAsociado()
                            nuevoTipoAsociado.nombre = params?.otro
                            nuevoTipoAsociado.prestacionReclamada = tipoAsociadoAgregado.prestacionReclamada
                            nuevoTipoAsociado.save(flush: true)
                            tipoAsociadoAgregado = nuevoTipoAsociado
                        }
                        tiposAsociados << tipoAsociadoAgregado
                    }
                }
            } else if (juicio.materia.id == 3){
                def paramsDelitos = params.findAll{it.key.startsWith("DELITO_")}
                def delitoAgregado
                delitos = []
                paramsDelitos.each{ key, value ->
                    if(value.equals('on')){
                        delitoAgregado = Delito.get((key.minus('DELITO_')) as long)
                        log.info delitoAgregado?.nombre
                        if(delitoAgregado.nombre.equals("OTRO")){
                            log.info "si entra"
                            def nuevoDelito = new Delito()
                            nuevoDelito.nombre = params?.otro
                            nuevoDelito.tipoDeAsignacion = delitoAgregado.tipoDeAsignacion
                            nuevoDelito.save(flush: true)
                            delitoAgregado = nuevoDelito
                        }
                        delitos << delitoAgregado
                    }
                }            
            }
        
            if (juicio == null) {
                transactionStatus.setRollbackOnly()
                notFound()
                return
            }
        
            def actores = []
            if(session.listaDeActores){
                session.listaDeActores.each { mapa ->
                    def actorJuicio = new ActorJuicio()
                    actorJuicio.persona = mapa.persona
                    actorJuicio.tipoDeParte = mapa.tipoDeParte
                    actorJuicio.fechaDeRegistro = new Date()
                    actorJuicio.cantidadDemandada = (mapa.cantidadDemandada as int)
                    actorJuicio.usuarioQueRegistro = springSecurityService.currentUser
                    actores << actorJuicio
                }
            }
            if(session.listaDeDemandados){
                session.listaDeDemandados.each { mapa ->
                    def actorJuicio = new ActorJuicio()
                    actorJuicio.persona = mapa.persona
                    actorJuicio.tipoDeParte = mapa.tipoDeParte
                    actorJuicio.fechaDeRegistro = new Date()
                    actorJuicio.usuarioQueRegistro = springSecurityService.currentUser
                    actores << actorJuicio
                }
            }
            if(session.listaDeTerceros){
                session.listaDeTerceros.each { mapa ->
                    def actorJuicio = new ActorJuicio()
                    actorJuicio.persona = mapa.persona
                    actorJuicio.tipoDeParte = mapa.tipoDeParte
                    actorJuicio.fechaDeRegistro = new Date()
                    actorJuicio.usuarioQueRegistro = springSecurityService.currentUser
                    actores << actorJuicio
                }
            }
            if(session.listaDeDenunciantes){
                session.listaDeDenunciantes.each { mapa ->
                    def actorJuicio = new ActorJuicio()
                    actorJuicio.persona = mapa.persona
                    actorJuicio.tipoDeParte = mapa.tipoDeParte
                    actorJuicio.fechaDeRegistro = new Date()
                    actorJuicio.usuarioQueRegistro = springSecurityService.currentUser
                    actores << actorJuicio
                }
            }
            if(session.listaDeResponsables){
                session.listaDeResponsables.each { mapa ->
                    def actorJuicio = new ActorJuicio()
                    actorJuicio.persona = mapa.persona
                    actorJuicio.tipoDeParte = mapa.tipoDeParte
                    actorJuicio.fechaDeRegistro = new Date()
                    actorJuicio.usuarioQueRegistro = springSecurityService.currentUser
                    actores << actorJuicio
                }
            } else if(params.responsableZ?.equals('on')){
                def actorJuicio = new ActorJuicio()
                actorJuicio.persona = Persona.get(0)
                actorJuicio.tipoDeParte = TipoDeParte.get(7)
                actorJuicio.fechaDeRegistro = new Date()
                actorJuicio.usuarioQueRegistro = springSecurityService.currentUser
                actores << actorJuicio
            }
            log.info("ESTA ES LA LISTA DE ACTORES: " + actores)
            
            if(actores.isEmpty()){
                log.info("La lista de actores está vacía")
                respuesta.exito = false
                respuesta.actoresJuicio = "No se han registrado actores para el juicio"
                respuesta.mensaje = "Por favor agregue personas para poder continuar con la creación del juicio"
            } else {
                log.info("La lista contiene actores")
            }
            
            if(juicio.save(flush:true)){
                def controlJuicio =  new ControlJuicio()
                controlJuicio.juicio = juicio
                controlJuicio.save(flush:true)
                numerosDeCredito?.each{
                    def creditoJuicio = new CreditoJuicio()
                    creditoJuicio.numeroDeCredito = it
                    creditoJuicio.juicio = juicio
                    if(creditoJuicio.save(flush:true)){
                        log.info "numero de credito: si lo registro"
                    } else{
                        log.info "numero de credito: no lo registro"
                    }
                }
                tiposAsociados?.each{
                    def tipoAsociadoJuicio = new TipoAsociadoJuicio()
                    tipoAsociadoJuicio.tipoAsociado = it
                    tipoAsociadoJuicio.juicio = juicio
                    if(tipoAsociadoJuicio.save(flush:true)){
                        log.info "tipo asociado: si lo registro"
                    } else{
                        log.info "tipo asociado: no lo registro"
                    }
                }
                delitos?.each{
                    def delitoJuicio = new DelitoJuicio()
                    delitoJuicio.delito = it
                    delitoJuicio.juicio = juicio
                    if(delitoJuicio.save(flush:true)){
                        log.info "delito: si lo registro"
                    } else{
                        log.info "delito: no lo registro"
                    }                
                }
                actores?.each{
                    it.juicio = juicio
                    if(it.save(flush:true)){
                        log.info "actor: si lo registro"
                    } else{
                        log.info "actor: no lo registro"
                    } 
                }
                if(ubicacionDelInmuebleJuicio){
                    ubicacionDelInmuebleJuicio.juicio = juicio
                    if(ubicacionDelInmuebleJuicio.save(flush:true)){
                        log.info "ubicacion: si lo registro"
                    } else{
                        log.info "ubicacion: no lo registro"
                    }
                }
                if(banderaNotificacionFinado == true){
                    notificacionJuicio.juicio = juicio
                    notificacionJuicio.textoNotificacion = mensajeDetallesFinado
                    notificacionJuicio.tipoNotificacion = 'WARNING'
                    if(notificacionJuicio.save(flush:true)){
                        log.info "notificacion: si lo registro"
                    } else{
                        log.info "notificacion: no lo registro"
                    }
                }
                respuesta.exito = true
                respuesta.url = "/sicj/juicio/show/" + juicio?.id
            } else{
                if (juicio.hasErrors()) {
                    juicio.errors.each{
                        log.info it
                    }
                    respuesta.exito = false
                    respuesta.errores = juicio.errors
                }
            }
        }
        //}
        render respuesta as JSON
    }

    def edit(Juicio juicio) {
        if(juicio){
            if(juicio.estadoDeJuicio.id == 1 || juicio.estadoDeJuicio.id == 2 || juicio.estadoDeJuicio.id == 5) {
                //def materia = juicio.materia.id
                def materiaJuicio
                if (juicio.materia.id == 1){
                    materiaJuicio = 1
                } else if (juicio.materia.id == 2) {
                    materiaJuicio = 2
                } else if (juicio.materia.id == 3) {
                    materiaJuicio = 3
                } else if (juicio.materia.id == 4) {
                    materiaJuicio = 4
                }
                log.info "ESTA ES LA MATERIA -> " + materiaJuicio
                def responsableDelDespacho = (juicio.responsableDelDespacho ?: Usuario.findWhere(despacho: juicio?.despacho, responsableDelDespacho: true, enabled: true))
                def gerenteJuridico = (juicio.gerenteJuridico ?: Usuario.findWhere(delegacion: juicio?.delegacion, gerenteJuridico: true, enabled: true))
                def numerosDeCredito = (CreditoJuicio.findAllWhere(juicio: juicio))*.numeroDeCredito
                def delitosJuicio = (DelitoJuicio.findAllWhere(juicio: juicio))*.delito
                def tiposAsociadosJuicio = (TipoAsociadoJuicio.findAllWhere(juicio: juicio))*.tipoAsociado
                
                log.info "ESTOS SON LOS TIPOS ASOCIADOS -> " + tiposAsociadosJuicio
                
                def ubicacionDelInmueble = UbicacionDelInmuebleJuicio.findWhere(juicio: juicio)
                def actores = ActorJuicio.findAllWhere(juicio: juicio)
                def usuarios = UsuarioJuicio.findAllWhere(juicio: juicio)
                def prestacionReclamada = ((juicio.materia.id == 1 || juicio.materia.id == 2) ? (tiposAsociadosJuicio*.prestacionReclamada as Set) : (delitosJuicio*.tipoDeAsignacion as Set))
                def listaDespachos = Despacho.findAllWhere(delegacion: juicio?.delegacion)
                def listaMunicipios =  (Municipio.executeQuery("SELECT am.municipio FROM AutoridadMunicipio am WHERE am.municipio.estado = :estado", [estado: juicio.delegacion.estado])) as Set
                listaMunicipios = listaMunicipios.sort { it.nombre }
                def listaAutoridades
                if(juicio.materia.id == 1 || juicio.materia.id == 2) {
                    listaAutoridades = Autoridad.executeQuery("SELECT am.autoridad FROM AutoridadMunicipio am WHERE am.autoridad.activo = true AND am.municipio = :municipio AND am.autoridad.tipoDeAutoridad = :tipoDeAutoridad AND am.autoridad.materia = :materia", [municipio: juicio.municipioAutoridad, tipoDeAutoridad: juicio.autoridad?.tipoDeAutoridad, materia: juicio.materia])
                } else {
                    listaAutoridades = Autoridad.executeQuery("SELECT am.autoridad FROM AutoridadMunicipio am WHERE am.autoridad.activo = true AND am.municipio = :municipio AND am.autoridad.materia = :materia", [municipio: juicio.municipioAutoridad, materia: juicio.materia])
                }
                def listaJuzgados = ((TipoDeAutoridad.executeQuery("SELECT am.autoridad FROM AutoridadMunicipio am WHERE am.municipio = :municipio", [municipio: juicio.municipioAutoridad]))*.tipoDeAutoridad) as Set
                listaJuzgados = listaJuzgados.sort { it.nombre }
                [juicio: juicio, responsableDelDespacho: responsableDelDespacho, gerenteJuridico: gerenteJuridico, numerosDeCredito: numerosDeCredito?.join(', '), delitosJuicio: delitosJuicio, tiposAsociadosJuicio: tiposAsociadosJuicio, ubicacionDelInmueble: ubicacionDelInmueble, actores: actores, usuarios: usuarios, prestacionReclamada: prestacionReclamada?.getAt(0), listaDespachos: listaDespachos, listaMunicipios: listaMunicipios, listaAutoridades: listaAutoridades, listaJuzgados: listaJuzgados]
            } else {
                [mensaje: "El juicio " + juicio.expedienteInterno + " no puede ser editado, ya que se encuentran en el status " + juicio.estadoDeJuicio + "."]
            }
        } else {
            [juicio: juicio]   
        }
    }
       
    @Transactional
    def cambiarEstadoJuicio(){
        log.info params
        if(params.id){
            def juicio = Juicio.get(params.id as long)
            def estadoDeJuicio = EstadoDeJuicio.get(params.estado as long)
            def tieneProcesosAlternosAbiertos = false
            def procesosAlternos = ProcesoAlternoJuicio.findAllWhere(juicio: juicio)
            procesosAlternos?.each {
                if(it.estadoDeProceso.id == 1){
                    tieneProcesosAlternosAbiertos = true
                }
            }
            if(tieneProcesosAlternosAbiertos && estadoDeJuicio.id == 2){
                flash.error = "El Juicio cuenta con un proceso alterno abierto, debe concluirlos para poder terminar el juicio."
            } else {
                juicio.estadoDeJuicio = estadoDeJuicio
                juicio.ultimaModificacion = new Date()
                juicio.personaQueModifico = springSecurityService.currentUser
                if(estadoDeJuicio.id == 2){
                    juicio.fechaDeTermino = ((params.fechaDeTermino) ? new Date().parse('dd/MM/yyyy',params.fechaDeTermino) : null)
                    juicio.fechaRegistroDeTermino = new Date()
                    juicio.terminadoPor = springSecurityService.currentUser
                    juicio.motivoDeTermino = ((params.motivoDeTermino && !params.motivoDeTermino?.equals('')) ? MotivoDeTermino.get(params.motivoDeTermino as long) : null)
                    if(params.juicioPagado && params.juicioPagado.equals("SI")){
                        juicio.juicioPagado = true
                        juicio.cantidadPagada = params.cantidadPagada as long
                        juicio.formaDePago = ((params.formaDePago && !params.formaDePago?.equals('')) ? FormaDePago.get(params.formaDePago as long) : null)
                    } else {
                        juicio.juicioPagado = false
                    }
                } else {
                    def controlJuicio = ControlJuicio.findWhere(juicio: juicio)
                    if(estadoDeJuicio.id == 1){
                        controlJuicio.fechaDeReactivacion = new Date()
                        controlJuicio.reactivadoPor = springSecurityService.currentUser
                    } else if(estadoDeJuicio.id == 4){
                        controlJuicio.fechaDeCancelacion = new Date()
                        controlJuicio.canceladoPor = springSecurityService.currentUser
                    } else if(estadoDeJuicio.id == 6){
                        controlJuicio.fechaDeArchivoDefinitivo = new Date()
                        controlJuicio.archivadoPor = springSecurityService.currentUser
                    } else if(estadoDeJuicio.id == 7){
                        controlJuicio.fechaDeArchivoHistorico = new Date()
                        controlJuicio.enviadoHistoricoPor = springSecurityService.currentUser
                    }
                    controlJuicio.save(flush:true)
                }
                if(juicio.save(flush: true)){
                    def bitacoraDeJuicio = new BitacoraDeJuicio()
                    bitacoraDeJuicio.juicio = juicio
                    bitacoraDeJuicio.estadoDeJuicio = estadoDeJuicio
                    bitacoraDeJuicio.usuario = springSecurityService.currentUser
                    bitacoraDeJuicio.fechaDeMovimiento = new Date()//TODO filtrar por estado
                    bitacoraDeJuicio.observaciones = params.observacionesFinales
                    bitacoraDeJuicio.save(flush:true)
                } else{
                    //TODO colocar mensaje de error para regresarlo a la vista
                }
            }
            redirect(action: "show", id: juicio.id)
        } else { 
            redirect(action: "search")
        }
    }
    
    @Transactional    
    def reactivarJuicio(){
        log.info params
        if(params.reactivarJuicioId){
            def juicio = Juicio.get(params.reactivarJuicioId as long)
            def controlJuicio = ControlJuicio.findWhere(juicio: juicio)
            def estadoDeJuicio = EstadoDeJuicio.get(1 as long)
            def etapaProcesal = EtapaProcesal.get(params.etapaProcesal.id as long)
            def ultimaPregunta = PreguntaEtapaProcesal.get(params.pregunta.id as long)
            def tipoDeReproceso = TipoDeReproceso.get(params.tipoDeReproceso.id as long)
            juicio.estadoDeJuicio = estadoDeJuicio
            juicio.etapaProcesal = etapaProcesal
            juicio.ultimaPregunta = ultimaPregunta
            juicio.ultimaModificacion = new Date()
            juicio.personaQueModifico = springSecurityService.currentUser
            juicio.tipoDeReproceso = tipoDeReproceso
            controlJuicio.fechaDeReactivacion = new Date()
            controlJuicio.reactivadoPor = springSecurityService.currentUser
            controlJuicio.save(flush:true)
            if(juicio.save(flush: true)){
                def bitacoraDeJuicio = new BitacoraDeJuicio()
                bitacoraDeJuicio.juicio = juicio
                bitacoraDeJuicio.estadoDeJuicio = estadoDeJuicio
                bitacoraDeJuicio.usuario = springSecurityService.currentUser
                bitacoraDeJuicio.fechaDeMovimiento = new Date()
                bitacoraDeJuicio.observaciones = "REPROCESO (" + tipoDeReproceso.nombre + "): " + params.observaciones
                bitacoraDeJuicio.save(flush:true)
                if(tipoDeReproceso.id == 1){
                    juicioService.eliminarPreguntasAnteriores(ultimaPregunta, juicio)
                }
            } else{
                //TODO colocar mensaje de error para regresarlo a la vista
            }
            redirect(action: "show", id: juicio.id)
        } else { 
            redirect(action: "show", id: juicio.id)
        }
    }
    
    @Transactional
    def cambiarProvisionJuicio(){
        log.info params
        if(params.id){
            def juicio = Juicio.get(params.id as long)
            def provision = Provision.get(params.provision.id as long)
            juicio.provision = provision
            juicio.ultimaModificacion = new Date()
            juicio.personaQueModifico = springSecurityService.currentUser
            if(juicio.save(flush: true)){
                def bitacoraDeJuicio = new BitacoraDeJuicio()
                bitacoraDeJuicio.juicio = juicio
                bitacoraDeJuicio.estadoDeJuicio = juicio.estadoDeJuicio
                bitacoraDeJuicio.usuario = springSecurityService.currentUser
                bitacoraDeJuicio.fechaDeMovimiento = new Date()
                bitacoraDeJuicio.observaciones = "CAMBIO DE PROVISION: " + provision.nombre
                bitacoraDeJuicio.save(flush:true)
                redirect(action: "show", id: juicio.id)
            } else{
                redirect(action: "search")
            }
        } else { 
            redirect(action: "search")
        }
    }

    @Transactional
    def update() {
        log.info params
        def juicio = Juicio.get(params.id as long)
        def numerosDeCredito
        def ubicacionDelInmuebleJuicio
        def tiposAsociados
        def delitos
        
        juicio.despacho = ((params.despacho?.id && !params.despacho?.id?.equals('')) ? Despacho.get(params.despacho.id as long) : null)
        juicio.region = ((params.region?.id && !params.region?.id?.equals('')) ? Region.get(params.region.id as long) : null)
        juicio.patrocinadoDelJuicio = ((params.patrocinadoDelJuicio?.id && !params.patrocinadoDelJuicio?.id?.equals('')) ? PatrocinadorDelJuicio.get(params.patrocinadoDelJuicio.id as long) : null)
        juicio.provision = ((params.provision?.id && !params.provision?.id?.equals('')) ? Provision.get(params.provision.id as long) : null)
        juicio.autoridad = ((params.autoridad?.id && !params.autoridad?.id?.equals('')) ? Autoridad.get(params.autoridad.id as long) : null)
        juicio.municipioAutoridad = ((params.municipioAutoridad?.id && !params.municipioAutoridad?.id?.equals('')) ? Municipio.get(params.municipioAutoridad.id as long) : null)
        juicio.expedienteInterno = params.expedienteInterno
        juicio.expediente = (params.expediente ? params.expediente : params.numeroDeAsignacion)
        juicio.antecedentes = params.antecedentes
        juicio.finado = ((params.finado?.equals("SI")) ? true : false)
        juicio.subprocuraduria = params?.subprocuraduria
        juicio.unidadEspecializada = params?.unidadEspecializada
        juicio.fiscalia = params?.fiscalia
        juicio.agencia = params?.agencia
        juicio.numeroDeCausaPenal = params?.numeroDeCausaPenal
        juicio.otraInstancia = params?.otraInstancia
        juicio.mesaInvestigadora = params?.mesaInvestigadora
        juicio.notario = params?.notario
        juicio.ultimaModificacion = new Date()
        juicio.personaQueModifico = springSecurityService.currentUser
        if(juicio.finado){
            juicio.nombreDelFinado = params.nombreDelFinado
            juicio.numeroSeguroSocialDelFinado = params.numeroSeguroSocialDelFinado
        }
        juicio.cantidadDemandada = ((params.cantidadDemandada?.equals("SI") || params.danoPatrimonial?.equals("SI")) ? true : false)
        if(juicio.cantidadDemandada){
            if(params.monto) {
                juicio.monto = params.monto as long
            } else {
                juicio.monto = 0
            }
            //juicio.tipoDeMoneda = TipoDeMoneda.get(params.tipoDeMoneda.id as long)
        }
        if(params.numeroDeCredito){
            numerosDeCredito = (params.numeroDeCredito).tokenize(",")
        }
        if(params.ubicacionCalle || params.ubicacionEstado?.id || params.ubicacionMunicipio?.id || params.ubicacionNumeroExterior || params.ubicacionNumeroInterior || params.ubicacionColonia || params.ubicacionCP){
            ubicacionDelInmuebleJuicio = new UbicacionDelInmuebleJuicio()
            ubicacionDelInmuebleJuicio.calle = params.ubicacionCalle
            ubicacionDelInmuebleJuicio.estado = ((params.ubicacionEstado?.id && !params.ubicacionEstado?.id?.equals('')) ? Estado.get(params.ubicacionEstado.id as long) : null)
            ubicacionDelInmuebleJuicio.municipio = ((params.ubicacionMunicipio?.id && !params.ubicacionMunicipio?.id?.equals('')) ? Municipio.get(params.ubicacionMunicipio.id as long) : null)
            ubicacionDelInmuebleJuicio.colonia = params.ubicacionColonia
            ubicacionDelInmuebleJuicio.numeroExterior = params.ubicacionNumeroExterior
            ubicacionDelInmuebleJuicio.numeroInterior = params.ubicacionNumeroInterior
            ubicacionDelInmuebleJuicio.codigoPostal = params.ubicacionCP
        }
        
        if(juicio.materia.id == 1 || juicio.materia.id == 2){
            def paramsTiposAsociados = params.findAll{it.key.startsWith("TASOCIADO_")}
            def tipoAsociadoAgregado
            tiposAsociados = []
            paramsTiposAsociados.each{ key, value ->
                if(value.equals('on')){
                    tipoAsociadoAgregado = TipoAsociado.get((key.minus('TASOCIADO_')) as long)
                    log.info tipoAsociadoAgregado?.nombre
                    if(tipoAsociadoAgregado?.nombre == "OTRO"){
                        log.info "si entra"
                        def nuevoTipoAsociado = new TipoAsociado()
                        nuevoTipoAsociado.nombre = params?.otro
                        nuevoTipoAsociado.prestacionReclamada = tipoAsociadoAgregado.prestacionReclamada
                        nuevoTipoAsociado.save(flush: true)
                        tipoAsociadoAgregado = nuevoTipoAsociado
                    }
                    tiposAsociados << tipoAsociadoAgregado
                }
            }
        } else if (juicio.materia.id == 3){
            def paramsDelitos = params.findAll{it.key.startsWith("DELITO_")}
            def delitoAgregado
            delitos = []
            paramsDelitos.each{ key, value ->
                if(value.equals('on')){
                    delitoAgregado = Delito.get((key.minus('DELITO_')) as long)
                    log.info delitoAgregado?.nombre
                    if(delitoAgregado?.nombre == "OTRO"){
                        log.info "si entra"
                        def nuevoDelito = new Delito()
                        nuevoDelito.nombre = params?.otro
                        nuevoDelito.tipoDeAsignacion = delitoAgregado.tipoDeAsignacion
                        nuevoDelito.save(flush: true)
                        delitoAgregado = nuevoDelito
                    }
                    delitos << delitoAgregado
                }
            }            
        }
        
        if (juicio == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if(juicio.save(flush:true)){
            def bitacoraDeJuicio = new BitacoraDeJuicio()
            bitacoraDeJuicio.juicio = juicio
            bitacoraDeJuicio.estadoDeJuicio = juicio.estadoDeJuicio
            bitacoraDeJuicio.usuario = springSecurityService.currentUser
            bitacoraDeJuicio.fechaDeMovimiento = new Date()
            bitacoraDeJuicio.observaciones = "EDICION GENERAL DEL JUICIO"
            bitacoraDeJuicio.save(flush:true)
            
            CreditoJuicio.executeUpdate("delete CreditoJuicio cj where cj.juicio = :juicio", [juicio:juicio])
            numerosDeCredito?.each{
                def creditoJuicio = new CreditoJuicio()
                creditoJuicio.numeroDeCredito = it
                creditoJuicio.juicio = juicio
                if(creditoJuicio.save(flush:true)){
                    log.info "numero de credito: si lo registro"
                } else{
                    log.info "numero de credito: no lo registro"
                }
            }
            TipoAsociadoJuicio.executeUpdate("delete TipoAsociadoJuicio taj where taj.juicio = :juicio", [juicio:juicio])
            tiposAsociados?.each{
                def tipoAsociadoJuicio = new TipoAsociadoJuicio()
                tipoAsociadoJuicio.tipoAsociado = it
                tipoAsociadoJuicio.juicio = juicio
                if(tipoAsociadoJuicio.save(flush:true)){
                    log.info "tipo asociado: si lo registro"
                } else{
                    log.info "tipo asociado: no lo registro"
                }
            }
            DelitoJuicio.executeUpdate("delete DelitoJuicio dj where dj.juicio = :juicio", [juicio:juicio])
            delitos?.each{
                def delitoJuicio = new DelitoJuicio()
                delitoJuicio.delito = it
                delitoJuicio.juicio = juicio
                if(delitoJuicio.save(flush:true)){
                    log.info "delito: si lo registro"
                } else{
                    log.info "delito: no lo registro"
                }                
            }
            UbicacionDelInmuebleJuicio.executeUpdate("delete UbicacionDelInmuebleJuicio uij where uij.juicio = :juicio", [juicio:juicio])
            if(ubicacionDelInmuebleJuicio){
                ubicacionDelInmuebleJuicio.juicio = juicio
                if(ubicacionDelInmuebleJuicio.save(flush:true)){
                    log.info "ubicacion: si lo registro"
                } else{
                    log.info "ubicacion: no lo registro"
                }
            }

        } else{
            if (juicio.hasErrors()) {
                juicio.errors.each{
                    log.info it
                }
                transactionStatus.setRollbackOnly()
                render view:'edit', model: [errors: juicio.errors, juicio: juicio]
                return
            }
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'juicio.label', default: 'Juicio'), juicio.id])
                redirect juicio
            }
            '*'{ respond juicio, [status: OK] }
        }
    }

    @Transactional
    def delete(Juicio juicio) {

        if (juicio == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        juicio.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'juicio.label', default: 'Juicio'), juicio.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'juicio.label', default: 'Juicio'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
    
    def search() {
        [usuario: springSecurityService.currentUser]
    }
    
    def verificarReasignacion(){
        log.info params
        def respuesta = [:]
        if(params.delegacionOrigen && params.delegacionDestino && params.despachoOrigen && params.despachoDestino){
            def delegacionOrigen = Delegacion.get(params.delegacionOrigen.id as long)
            log.info "DELEGACION ORIGEN -> " + delegacionOrigen.id
            def despachoOrigen = Despacho.get(params.despachoOrigen.id as long)
            log.info "DESPACHO ORIGEN -> " + despachoOrigen.id
            def delegacionDestino = Delegacion.get(params.delegacionDestino.id as long)
            log.info "DELEGACION DESTINO -> " + delegacionDestino.id
            def despachoDestino = Despacho.get(params.despachoDestino.id as long)
            log.info "DESPACHO DESTINO -> " + despachoDestino.id
            
            def queryJuicioOrigen = Juicio.findByDelegacionAndDespacho(delegacionOrigen, despachoOrigen)
            if(queryJuicioOrigen){
                Juicio.executeUpdate("update Juicio j set j.despacho =:despachoDestino, j.delegacion =:delegacionDestino where j.despacho =:despachoOrigen and j.delegacion =:delegacionOrigen", 
                    [despachoDestino:despachoDestino, delegacionDestino:delegacionDestino, despachoOrigen:despachoOrigen, delegacionOrigen:delegacionOrigen])
                log.info "REGISTROS ACTUALIZADOS"                    
                respuesta.queryJuicioOrigen = queryJuicioOrigen
                render respuesta as JSON
            }
            else{
                respuesta.queryJuicioOrigen = queryJuicioOrigen
                render respuesta as JSON
            }
        }
        else{
            render(text: "<center><div class='alert alert-danger'>Seleccione la delegación origen y destino y a su vez el despacho origen y destino correspondientes</div></center>", contentType: "text/html", encoding: "UTF-8")
        } 
    }
    
    def obtenerCantidadJuicios(){
        log.info params
        def respuesta = [:]
        def delegacion = Delegacion.get(params.delegacion)
        def despacho = Despacho.get(params.despacho)
        def cantidadJuicios = 0
        def consulta = Juicio.createCriteria()
        cantidadJuicios = consulta.get{
            eq("delegacion", delegacion)
            eq("despacho", despacho)
            projections{
                countDistinct "id"
            }
        }
        log.info "CANTIDAD DE JUICIOS POSIBLES A REASIGNAR -> " + cantidadJuicios
        respuesta.cantidadJuicios = cantidadJuicios
        log.info "RESPUESTA -> " + respuesta
        render respuesta as JSON
    }
    
     def realizarBusqueda() {
        log.info params
        def queryActor
        def queryDemandado
        def query = "SELECT j from Juicio j WHERE id > 0 "
        def resultados = []
        def resultadosFiltro = []
        def resultadosActor = []
        def resultadosDemandado = []
        def listaDeActores = []
        def usuario = springSecurityService.currentUser
        def roles = springSecurityService.principal?.authorities*.authority
        if( (!roles.contains('ROLE_ADMIN')) && (roles.contains('ROLE_CONSULTA_JUICIO_LABORAL') || roles.contains('ROLE_CONSULTA_JUICIO_CIVIL') || roles.contains('ROLE_CONSULTA_JUICIO_PENAL'))){
            params.delegacion = usuario.delegacion
        }
        if(usuario.tipoDeUsuario == 'EXTERNO'){
            params.despacho = usuario.despacho
        }
        if(params.busquedaExternaExpediente){
            def tipoDeConsulta = params.tipoDeConsulta as int
            def campoAConsultar = (tipoDeConsulta == 1 ? "expedienteInterno" : "expediente" )
            query += "AND j." + campoAConsultar + " = '" + params.busquedaExternaExpediente + "' "
        }
        if(params.materia?.id && params.materia?.id != null  && params.materia?.id != 'null'){
            query += "AND j.materia.id = " + params.materia.id + " "
        }
        if(params.ambito?.id && params.ambito?.id != null  && params.ambito?.id != 'null'){
            query += "AND j.ambito.id = " + params.ambito.id + " "
        }
        if(params.estadoDeJuicio?.id && params.estadoDeJuicio?.id != null && params.estadoDeJuicio?.id != 'null'){
            query += "AND j.estadoDeJuicio.id = " + params.estadoDeJuicio.id + " "
        }
        if(params.delegacion?.id && params.delegacion?.id != null && params.delegacion?.id != 'null'){
            query += "AND j.delegacion.id = " + params.delegacion.id + " "
        }
        if(params.despacho?.id && params.despacho?.id != null && params.despacho?.id != 'null'){
            query += "AND j.despacho.id = " + params.despacho.id + " "
        }
        if(params.expediente){
            query += "AND j.expediente = '" + params.expediente + "' "
        }
        if(params.expedienteInterno){
            query += "AND j.expedienteInterno = '" + params.expedienteInterno + "' "
        }
        if(params.tipoDeProcedimiento?.id && params.tipoDeProcedimiento?.id != null && params.tipoDeProcedimiento?.id != 'null'){
            query += "AND j.tipoDeProcedimiento.id = " + params.tipoDeProcedimiento.id + " "
        }
        if(params.etapaProcesal?.id && params.etapaProcesal?.id != null && params.etapaProcesal?.id != 'null'){
            query += "AND j.etapaProcesal.id = " + params.etapaProcesal.id + " "
        }
        if(params.anio){
            //query += "AND j.fechaDeCreacion between to_timestamp('01/01/" + params.anio + " 00:00','dd/mm/yyyy hh24:mi') and to_timestamp('31/12/" + params.anio + " 23:59','dd/mm/yyyy hh24:mi') "
            query += "AND j.fechaDeCreacion between convert(datetime, '01/01/" + params.anio + " 00:00',103) and convert(datetime, '31/12/" + params.anio + " 23:59',103) "
        }
        query += "ORDER BY j.fechaDeCreacion ASC" 
        if( params.tipoDeConsulta && (params.tipoDeConsulta as int) == 10){
            query = "SELECT cj.juicio FROM CreditoJuicio cj WHERE cj.numeroDeCredito = '" + params.busquedaExternaExpediente + "' "
            if(params.delegacion){
                query += "AND cj.juicio.delegacion.id = " + params.despacho.id + " "
            }
            if(params.despacho){
                query += "AND cj.juicio.despacho.id = " + params.despacho.id + " "
            }
            query += "ORDER BY cj.juicio.fechaDeCreacion ASC"
        }
        log.info query
        resultadosFiltro = Juicio.executeQuery(query)
        log.info "Filtrado: " + resultadosFiltro.size()
        if(params.idActor){
            queryActor = "SELECT a.juicio from ActorJuicio a WHERE a.persona.id = " + params.idActor
            if(params.materia?.id == "3"){
                queryActor += " and a.tipoDeParte.id = 6 ORDER BY a.juicio.fechaDeCreacion ASC"
            } else {
                queryActor += " and a.tipoDeParte.id = 5 ORDER BY a.juicio.fechaDeCreacion ASC"
            }
            log.info queryActor
            resultadosActor = Juicio.executeQuery(queryActor)
            log.info "Actores: " + resultadosActor.size()
        } 
        if(params.idDemandado){
            queryDemandado = "SELECT a.juicio from ActorJuicio a WHERE a.persona.id = " + params.idDemandado
            if(params.materia?.id == "3"){
                queryDemandado += " and a.tipoDeParte.id = 7 ORDER BY a.juicio.fechaDeCreacion ASC"
            } else {
                queryDemandado += " and a.tipoDeParte.id = 2 ORDER BY a.juicio.fechaDeCreacion ASC"
            }
            log.info queryDemandado
            resultadosDemandado = Juicio.executeQuery(queryDemandado)
            log.info "Demandados: " +resultadosDemandado.size()
        }
        if(resultadosActor.size() > 0 && resultadosDemandado.size()){
            resultados = resultadosActor.intersect(resultadosDemandado)
        } else if(resultadosActor.size() == 0 && resultadosDemandado.size()){
            resultados = resultadosDemandado
        } else {
            resultados = resultadosActor
        }
        if(resultados.size() > 0 && resultadosFiltro.size() > 0){
            resultados = resultados.intersect(resultadosFiltro)
        } else if (resultados.size() == 0 && resultadosFiltro.size() > 0){
            resultados = resultadosFiltro
        }
        log.info "Interseccion: " + resultados.size()
        resultados?.each {
            def actor = ActorJuicio.findAllWhere(juicio: it)
            if(actor){
                listaDeActores.addAll(actor)
            }
        }
        def (actores, otros) = (listaDeActores.split {(it.tipoDeParte.id == 5 || it.tipoDeParte.id == 6)})
        def (demandados, restantes) = (otros.split {(it.tipoDeParte.id == 2 || it.tipoDeParte.id == 7)})
        actores = actores.groupBy({it.juicio.id})
        demandados = demandados.groupBy({it.juicio.id})
        render(template: "/templates/resultadosBusqueda", model: [resultados: resultados, actores: actores, demandados: demandados])
    }
    
    def doSearch() {
        log.info params
        log.info "VALOR DEL AÑO -> " + params.anio
        boolean bandera = true
        def queryActor
        def queryDemandado
        def query = "SELECT j from Juicio j WHERE id > 0 "
        def resultados = []
        def resultadosFiltro = []
        def resultadosActor = []
        def resultadosDemandado = []
        def listaDeActores = []
        def usuario = springSecurityService.currentUser
        def roles = springSecurityService.principal?.authorities*.authority
        if( (!roles.contains('ROLE_ADMIN')) && (roles.contains('ROLE_CONSULTA_JUICIO_LABORAL') || roles.contains('ROLE_CONSULTA_JUICIO_CIVIL') || roles.contains('ROLE_CONSULTA_JUICIO_PENAL'))){
            params.delegacion = usuario.delegacion
        }
        if(usuario.tipoDeUsuario == 'EXTERNO'){
            params.despacho = usuario.despacho
        }
        if(params.busquedaExternaExpediente){
            def tipoDeConsulta = params.tipoDeConsulta as int
            def campoAConsultar = (tipoDeConsulta == 1 ? "expedienteInterno" : "expediente" )
            query += "AND j." + campoAConsultar + " = '" + params.busquedaExternaExpediente + "' "
        }
        if(params.materia?.id && params.materia?.id != null  && params.materia?.id != 'null'){
            query += "AND j.materia.id = " + params.materia.id + " "
        }
        if(params.ambito?.id && params.ambito?.id != null  && params.ambito?.id != 'null'){
            query += "AND j.ambito.id = " + params.ambito.id + " "
        }
        if(params.estadoDeJuicio?.id && params.estadoDeJuicio?.id != null && params.estadoDeJuicio?.id != 'null'){
            query += "AND j.estadoDeJuicio.id = " + params.estadoDeJuicio.id + " "
        }
        if(params.delegacion?.id && params.delegacion?.id != null && params.delegacion?.id != 'null'){
            query += "AND j.delegacion.id = " + params.delegacion.id + " "
        }
        if(params.despacho?.id && params.despacho?.id != null && params.despacho?.id != 'null'){
            query += "AND j.despacho.id = " + params.despacho.id + " "
        }
        if(params.expediente){
            query += "AND j.expediente = '" + params.expediente + "' "
        }
        if(params.expedienteInterno){
            query += "AND j.expedienteInterno = '" + params.expedienteInterno + "' "
        }
        if(params.tipoDeProcedimiento?.id && params.tipoDeProcedimiento?.id != null && params.tipoDeProcedimiento?.id != 'null'){
            query += "AND j.tipoDeProcedimiento.id = " + params.tipoDeProcedimiento.id + " "
        }
        if(params.etapaProcesal?.id && params.etapaProcesal?.id != null && params.etapaProcesal?.id != 'null'){
            query += "AND j.etapaProcesal.id = " + params.etapaProcesal.id + " "
        }
        if(params.idActor || params.idDemandado){
            bandera = true
            log.info "BANDERA -> " + bandera
        } else {          
            bandera = false
            log.info "BANDERA -> " + bandera
        }
        
        if(params.anio == '0'){
            if(bandera == false){
                log.info "NO TRAE AÑO NI ACTOR"
                render(template: "/templates/busquedaSinAnio")
            } else {
                log.info "NO TRAE AÑO PERO SI TRAE ACTOR"
                //query += "AND j.fechaDeCreacion between to_timestamp('01/01/" + params.anio + " 00:00','dd/mm/yyyy hh24:mi') and to_timestamp('31/12/" + params.anio + " 23:59','dd/mm/yyyy hh24:mi') "
                
                query += "ORDER BY j.fechaDeCreacion ASC" 
                if( params.tipoDeConsulta && (params.tipoDeConsulta as int) == 10){
                    query = "SELECT cj.juicio FROM CreditoJuicio cj WHERE cj.numeroDeCredito = '" + params.busquedaExternaExpediente + "' "
                    if(params.delegacion){
                        query += "AND cj.juicio.delegacion.id = " + params.despacho.id + " "
                    }
                    if(params.despacho){
                        query += "AND cj.juicio.despacho.id = " + params.despacho.id + " "
                    }
                    query += "ORDER BY cj.juicio.fechaDeCreacion ASC"
                }
                log.info query
                resultadosFiltro = Juicio.executeQuery(query)
                log.info "Filtrado: " + resultadosFiltro.size()
                if(params.idActor){
                    queryActor = "SELECT a.juicio from ActorJuicio a WHERE a.persona.id = " + params.idActor
                    if(params.materia?.id == "3"){
                        queryActor += " and a.tipoDeParte.id = 6 ORDER BY a.juicio.fechaDeCreacion ASC"
                    } else {
                        queryActor += " and a.tipoDeParte.id = 5 ORDER BY a.juicio.fechaDeCreacion ASC"
                    }
                    log.info queryActor
                    resultadosActor = Juicio.executeQuery(queryActor)
                    log.info "Actores: " + resultadosActor.size()
                } 
                if(params.idDemandado){
                    queryDemandado = "SELECT a.juicio from ActorJuicio a WHERE a.persona.id = " + params.idDemandado
                    if(params.materia?.id == "3"){
                        queryDemandado += " and a.tipoDeParte.id = 7 ORDER BY a.juicio.fechaDeCreacion ASC"
                    } else {
                        queryDemandado += " and a.tipoDeParte.id = 2 ORDER BY a.juicio.fechaDeCreacion ASC"
                    }
                    log.info queryDemandado
                    resultadosDemandado = Juicio.executeQuery(queryDemandado)
                    log.info "Demandados: " +resultadosDemandado.size()
                }
                if(resultadosActor.size() > 0 && resultadosDemandado.size()){
                    resultados = resultadosActor.intersect(resultadosDemandado)
                } else if(resultadosActor.size() == 0 && resultadosDemandado.size()){
                    resultados = resultadosDemandado
                } else {
                    resultados = resultadosActor
                }
                if(resultados.size() > 0 && resultadosFiltro.size() > 0){
                    resultados = resultados.intersect(resultadosFiltro)
                } else if (resultados.size() == 0 && resultadosFiltro.size() > 0){
                    resultados = resultadosFiltro
                }
                log.info "Interseccion: " + resultados.size()
                resultados?.each {
                    def actor = ActorJuicio.findAllWhere(juicio: it)
                    if(actor){
                        listaDeActores.addAll(actor)
                    }
                }
                def (actores, otros) = (listaDeActores.split {(it.tipoDeParte.id == 5 || it.tipoDeParte.id == 6)})
                def (demandados, restantes) = (otros.split {(it.tipoDeParte.id == 2 || it.tipoDeParte.id == 7)})
                actores = actores.groupBy({it.juicio.id})
                demandados = demandados.groupBy({it.juicio.id})
                render(template: "/templates/resultadosBusqueda", model: [resultados: resultados, actores: actores, demandados: demandados])
            }
        } else {
            //query += "AND j.fechaDeCreacion between to_timestamp('01/01/" + params.anio + " 00:00','dd/mm/yyyy hh24:mi') and to_timestamp('31/12/" + params.anio + " 23:59','dd/mm/yyyy hh24:mi') "
            query += "AND j.fechaDeCreacion between convert(datetime, '01/01/" + params.anio + " 00:00',103) and convert(datetime, '31/12/" + params.anio + " 23:59',103) "  
            
            query += "ORDER BY j.fechaDeCreacion ASC" 
            if( params.tipoDeConsulta && (params.tipoDeConsulta as int) == 10){
                query = "SELECT cj.juicio FROM CreditoJuicio cj WHERE cj.numeroDeCredito = '" + params.busquedaExternaExpediente + "' "
                if(params.delegacion){
                    query += "AND cj.juicio.delegacion.id = " + params.despacho.id + " "
                }
                if(params.despacho){
                    query += "AND cj.juicio.despacho.id = " + params.despacho.id + " "
                }
                query += "ORDER BY cj.juicio.fechaDeCreacion ASC"
            }
            log.info query
            resultadosFiltro = Juicio.executeQuery(query)
            log.info "Filtrado: " + resultadosFiltro.size()
            if(params.idActor){
                queryActor = "SELECT a.juicio from ActorJuicio a WHERE a.persona.id = " + params.idActor
                if(params.materia?.id == "3"){
                    queryActor += " and a.tipoDeParte.id = 6 ORDER BY a.juicio.fechaDeCreacion ASC"
                } else {
                    queryActor += " and a.tipoDeParte.id = 5 ORDER BY a.juicio.fechaDeCreacion ASC"
                }
                log.info queryActor
                resultadosActor = Juicio.executeQuery(queryActor)
                log.info "Actores: " + resultadosActor.size()
            } 
            if(params.idDemandado){
                queryDemandado = "SELECT a.juicio from ActorJuicio a WHERE a.persona.id = " + params.idDemandado
                if(params.materia?.id == "3"){
                    queryDemandado += " and a.tipoDeParte.id = 7 ORDER BY a.juicio.fechaDeCreacion ASC"
                } else {
                    queryDemandado += " and a.tipoDeParte.id = 2 ORDER BY a.juicio.fechaDeCreacion ASC"
                }
                log.info queryDemandado
                resultadosDemandado = Juicio.executeQuery(queryDemandado)
                log.info "Demandados: " +resultadosDemandado.size()
            }
            if(resultadosActor.size() > 0 && resultadosDemandado.size()){
                resultados = resultadosActor.intersect(resultadosDemandado)
            } else if(resultadosActor.size() == 0 && resultadosDemandado.size()){
                resultados = resultadosDemandado
            } else {
                resultados = resultadosActor
            }
            if(resultados.size() > 0 && resultadosFiltro.size() > 0){
                resultados = resultados.intersect(resultadosFiltro)
            } else if (resultados.size() == 0 && resultadosFiltro.size() > 0){
                resultados = resultadosFiltro
            }
            log.info "Interseccion: " + resultados.size()
            resultados?.each {
                def actor = ActorJuicio.findAllWhere(juicio: it)
                if(actor){
                    listaDeActores.addAll(actor)
                }
            }
            def (actores, otros) = (listaDeActores.split {(it.tipoDeParte.id == 5 || it.tipoDeParte.id == 6)})
            def (demandados, restantes) = (otros.split {(it.tipoDeParte.id == 2 || it.tipoDeParte.id == 7)})
            actores = actores.groupBy({it.juicio.id})
            demandados = demandados.groupBy({it.juicio.id})
            render(template: "/templates/resultadosBusqueda", model: [resultados: resultados, actores: actores, demandados: demandados])
        }
    }
    
    @Transactional
    def registrarAvanceWorkFlow() {
        log.info params
        log.info ("RESPUESTA -> " + params)
        def flujoJuicio =  new FlujoJuicio()
        boolean sinRespuestaNoObligatorio = false
        boolean flujoConcluido = false
        int preguntaSinResponder = 106
        def respuestaDelUsuario
        if(params.juicio){
            def juicio = Juicio.get(params.juicio as long)
            def preguntaAtendida = PreguntaEtapaProcesal.get(params.pregunta as long)
            //def respuestaDelUsuario = RespuestaPregunta.get(params.respuesta as long)
            def respuestas = []
            if (params.multiple) {                
                def paramsCheck = []
                if(params.respuestaCheck.class == java.lang.String) {
                    log.info "ENTRO AL JAVA STRING"
                    respuestas << RespuestaPregunta.get(params.respuestaCheck as long)
                } else {
                    log.info "ENTRO AL JAVA ARRAY LIST"
                    paramsCheck = params.respuestaCheck//params.findAll{it.key.startsWith("respuestaCheck")}
                    paramsCheck.each { value ->
                        log.info "value: " + value
                        /*if(value.equals('on')) {
                        respuestas << RespuestaPregunta.get((key.minus('respuestaCheck')) as long)
                        }*/
                        respuestas << RespuestaPregunta.get(value as long)
                    }
                }
                respuestaDelUsuario = respuestas.getAt(0)
                params.respuesta = respuestaDelUsuario.id
            } else if (params.respuesta) {   
                log.info ("RESPUESTA DEL USUARIO -> " + params)
                
                respuestaDelUsuario = RespuestaPregunta.get(params.respuesta as long)
            } else {
                respuestaDelUsuario = RespuestaPregunta.get(preguntaSinResponder as long)
                sinRespuestaNoObligatorio = true
                log.info ("NO HAY RESPUESTA |" + respuestaDelUsuario)
            }
            if(!params.valorRespuesta && preguntaAtendida.tipoDePregunta.id != 1 && preguntaAtendida.tipoDePregunta.id != 3 && preguntaAtendida.tipoDePregunta.id != 5 ){
                params.valorRespuesta = "NO SE PROPORCIONO EL DATO"
            }
            if (sinRespuestaNoObligatorio == true){
                log.info ("ENTRO A LA RESPUESTA NO OBLIGATORIA")
                flujoJuicio.fechaDeRespuesta = new Date()
                log.info("HIZO LA FECHA")
                flujoJuicio.juicio = juicio
                log.info("HIZO EL JUICIO")
                flujoJuicio.observaciones = params.observaciones
                log.info("HIZO LAS OBSERVACIONES")
                flujoJuicio.preguntaAtendida = preguntaAtendida
                log.info("HIZO LA PREGUNTA ATENDIDA")
                flujoJuicio.respuesta = respuestaDelUsuario
                log.info("HIZO EL RESPUESTA ID")
                flujoJuicio.usuarioQueResponde = springSecurityService.currentUser
                log.info ("TERMINO TODOS LOS FLUJO JUICIO")
                
            } else {
                flujoJuicio.preguntaAtendida = preguntaAtendida
                flujoJuicio.respuesta = respuestaDelUsuario
                flujoJuicio.usuarioQueResponde = springSecurityService.currentUser
                flujoJuicio.fechaDeRespuesta = new Date()
                flujoJuicio.valorRespuesta = (params.valorRespuesta ? params.valorRespuesta : (respuestas ? respuestas*.valorDeRespuesta.join(', ') : null))
                flujoJuicio.juicio = juicio
                flujoJuicio.observaciones = params.observaciones
                flujoJuicio.datoAuxiliar = (params.datoAuxiliar ? params.datoAuxiliar : (respuestas ? respuestas*.id.join(',') : null))
            }
            def respuesta = [:]
            if(flujoJuicio.save(flush:true)){
                log.info("GUARDO EL FLUJO JUICIO")
                juicio.ultimaPregunta = preguntaAtendida
                juicio.etapaProcesal = preguntaAtendida.etapaProcesal
                juicio.ultimaActualizacionWorkflow = new Date()
                juicio.ultimaPersonaQueActualizoWorkflow = springSecurityService.currentUser
                juicio.save(flash:true)
                log.info ("RESPUESTA DEL USUARIO |" + respuestaDelUsuario)
                if(juicioService.preguntaConcluyeProcedimiento(preguntaAtendida,respuestaDelUsuario, juicio.tipoDeParte)){
                    respuesta.terminaProcedimiento = true
                    respuesta.mensaje = "El procedimiento ha concluido."
                    juicio.estadoDeJuicio = EstadoDeJuicio.get(5)
                    flujoConcluido = true
                    log.info("FLUJO CONCLUIDO TRUE")
                } else { 
                    respuesta = juicioService.obtenerSiguientePregunta(params.juicio, params.respuesta)
                    juicio.ultimaPregunta = respuesta.pregunta.getAt(0)
                    if((juicio?.etapaProcesal != respuesta.pregunta.getAt(0).etapaProcesal) && (juicioService.esPrimerPregunta(respuesta.pregunta.getAt(0)))){
                        juicio.etapaProcesal = respuesta.pregunta.getAt(0).etapaProcesal
                    }
                }
                log.info respuesta
                juicio.save(flash:true)
                if(flujoConcluido){
                    def controlJuicio = ControlJuicio.findWhere(juicio: juicio)
                    controlJuicio.fechaDeWfTerminado = new Date()
                    controlJuicio.wfTerminadoPor = springSecurityService.currentUser
                    controlJuicio.save(flush:true)
                }
                render(template: "/templates/workFlow", model: [respuesta: respuesta, juicioId: juicio.id])
            } else {
                flujoJuicio
                respuesta.error = true
                respuesta.mensaje = "Ocurrio un error al registrar la pregunta. Intente nuevamente"
                render(template: "/templates/workFlow", model: [respuesta: respuesta, juicioId: juicio.id])
            }
        }
    }

    @Transactional
    def cargarReporte(){
        def respuesta = [:]
        def fileNames = request.getFileNames()
        def listaDeArchivos = []
        def mapa
        fileNames.each{ fileName ->
            def uploadedFile = request.getFile(fileName)
            def fileLabel = ".${uploadedFile.originalFilename.split("\\.")[-1]}"
            log.info uploadedFile
            log.info "NOMBRE DEL ARCHIVO -> " + uploadedFile.originalFilename
            log.info "TAMAÑO DEL ARCHIVO -> " + uploadedFile.size
            log.info "EXTENSIÓN DEL ARCHIVO -> " + fileLabel
            InputStream inputStream = uploadedFile.inputStream
            mapa = [:]
            mapa.archivo = inputStream
            mapa.nombreDelArchivo = uploadedFile.originalFilename
            listaDeArchivos << mapa
        }
        def existenciaRegistros = juicioService.verificaReasignacionJuicio(listaDeArchivos, params)
        respuesta.existenciaRegistros = existenciaRegistros
        session.respuesta = respuesta
        log.info "ESTA ES LA RESPUESTA -> " + respuesta
        render respuesta as JSON
        
//        def respuesta = [:]
//        def fileName = request.getFileNames()[0]
//        def uploadedFile = request.getFile(fileName)
//        def fileLabel = ".${uploadedFile.originalFilename.split("\\.")[-1]}"
//        log.info uploadedFile
//        log.info "File name :" + uploadedFile.originalFilename
//        log.info "File size :" + uploadedFile.size
//        log.info "File label :" + fileLabel
//        InputStream inputStream = uploadedFile.inputStream
//        def allLines = inputStream.toCsvReader().readAll()
//        def existenciaRegistros = juicioService.verificaReasignacionJuicio(allLines, params)
//        respuesta.existenciaRegistros = existenciaRegistros
//        session.respuesta = respuesta
//        log.info "ESTA ES LA RESPUESTA -> " + respuesta
//        render respuesta as JSON
    }
    
    @Transactional
    def cargarReporteTransferencia(){
        def respuesta = [:]
        def fileNames = request.getFileNames()
        def listaDeArchivos = []
        def mapa
        fileNames.each{ fileName ->
            def uploadedFile = request.getFile(fileName)
            def fileLabel = ".${uploadedFile.originalFilename.split("\\.")[-1]}"
            log.info uploadedFile
            log.info "NOMBRE DEL ARCHIVO -> " + uploadedFile.originalFilename
            log.info "TAMAÑO DEL ARCHIVO -> " + uploadedFile.size
            log.info "EXTENSIÓN DEL ARCHIVO -> " + fileLabel
            InputStream inputStream = uploadedFile.inputStream
            mapa = [:]
            mapa.archivo = inputStream
            mapa.nombreDelArchivo = uploadedFile.originalFilename
            listaDeArchivos << mapa
        }
        def existenciaRegistros = juicioService.verificaTransferenciaJuicio(listaDeArchivos, params)
        respuesta.existenciaRegistros = existenciaRegistros
        session.respuesta = respuesta
        log.info "ESTA ES LA RESPUESTA -> " + respuesta
        render respuesta as JSON
        
//        def respuesta = [:]
//        def fileName = request.getFileNames()[0]
//        def uploadedFile = request.getFile(fileName)
//        def fileLabel = ".${uploadedFile.originalFilename.split("\\.")[-1]}"
//        log.info uploadedFile
//        log.info "File name :" + uploadedFile.originalFilename
//        log.info "File size :" + uploadedFile.size
//        log.info "File label :" + fileLabel
//        InputStream inputStream = uploadedFile.inputStream
//        def allLines = inputStream.toXlsxReader().readAll()
//        def existenciaRegistros = juicioService.verificaTransferenciaJuicio(allLines, params)
//        respuesta.existenciaRegistros = existenciaRegistros
//        session.respuesta = respuesta
//        log.info "ESTA ES LA RESPUESTA -> " + respuesta
//        render respuesta as JSON
    } 
    
    @Transactional    
    def revisarArchivoActores(){
        log.info params
        def fileName = request.getFileNames()[0]
        def uploadedFile = request.getFile(fileName)
        def fileLabel = ".${uploadedFile.originalFilename.split("\\.")[-1]}"
        log.info uploadedFile
        log.info "File name :"+ uploadedFile.originalFilename
        log.info "File size :"+ uploadedFile.size
        log.info "File label :"+ fileLabel
        InputStream inputStream = uploadedFile.inputStream
        def allLines = inputStream.toCsvReader().readAll()
        def existencia = juicioService.verificarNombre(allLines)
        log.info existencia
        session.listaDeActores = existencia
        render session.listaDeActores as JSON
    }
    
    def descargarPlantilla(){
        log.info params
        def plataforma = System.properties['os.name'].toLowerCase()
        def file
        if(plataforma.contains('windows')){
            file = new File("C:/var/uploads/sicj/plantillas/plantillaActoresJuicioColectivo.csv")
        } else {
            file = new File("/var/uploads/sicj/plantillas/plantillaActoresJuicioColectivo.csv")
        }
        if (file?.exists()){
            response.setContentType("application/octet-stream") // or or image/JPEG or text/xml or whatever type the file is
            response.setHeader("Content-disposition", "attachment;filename=\"plantillaActoresJuicioColectivo.csv\"")
            response.outputStream << file.bytes
        } else {
            render "Error!"
        }
    }
    
    @Transactional    
    def agregarNota(){
        log.info params
        def juicio = Juicio.get(params.juicio as long)
        def texto = params.notaJuicio
        def nota = new NotaJuicio()
        def respuesta = [:]
        nota.juicio = juicio
        nota.nota = texto
        nota.fechaDeNota = new Date()
        nota.usuario = springSecurityService.currentUser
        if(nota.save(flush:true)){
            //juicio.ultimaModificacion = new Date()
            //juicio.personaQueModifico = springSecurityService.currentUser
            //juicio.save(flash:true)
            render(text: "<center><div class='alert alert-info alert-dismissable'><button aria-hidden='true' data-dismiss='alert' class='close' type='button'>×</button>Se ha registrado la nota correctamente.</div></center>", contentType: "text/html", encoding: "UTF-8")
        } else{
            render(text: "<center><div class='alert alert-danger alert-dismissable'><button aria-hidden='true' data-dismiss='alert' class='close' type='button'>×</button>Ha ocurrido un error al registrar la nota.</div></center>", contentType: "text/html", encoding: "UTF-8")
        }
    }
    
    @Transactional    
    def agregarAcuerdo(){
        log.info params
        def juicio = Juicio.get(params.acuerdoJuicioId as long)
        def fileNames = request.getFileNames()
        def listaDeArchivos = []
        def mapa
        fileNames.each{ fileName ->
            def uploadedFile = request.getFile(fileName)
            def fileLabel = ".${uploadedFile.originalFilename.split("\\.")[-1]}"
            log.info uploadedFile
            log.info "File name :"+ uploadedFile.originalFilename
            log.info "File size :"+ uploadedFile.size
            log.info "File label :"+ fileLabel
            InputStream inputStream = uploadedFile.inputStream
            mapa = [:]
            mapa.archivo = inputStream
            mapa.nombreDelArchivo = uploadedFile.originalFilename
            listaDeArchivos << mapa
        }
        def respuesta = juicioService.subirArchivo(listaDeArchivos, juicio.id)
        if(respuesta.exito){
            def acuerdo = new AcuerdoJuicio()
            acuerdo.juicio = juicio
            acuerdo.observaciones = params.observaciones
            acuerdo.fechaDePublicacion = new Date().parse('dd/MM/yyyy',params.fechaDePublicacion)
            acuerdo.usuarioQueRegistro = springSecurityService.currentUser
            acuerdo.rutaArchivo = respuesta.idArchivo
            if(acuerdo.save(flush:true)){
                juicio.ultimaModificacion = new Date()
                juicio.personaQueModifico = springSecurityService.currentUser
                juicio.save(flash:true)
                flash.message = "El acuerdo se ha agregado correctamente"
                redirect action: "show", id: juicio?.id
            } else{
                flash.error = "Ha ocurrido un error al guardar el acuerdo."
                redirect action: "show", id: juicio?.id
            }
        } else{
            flash.error = "Ha ocurrido un error al subir el archivo del acuerdo."
            redirect action: "show", id: juicio?.id
        }
    }
    
    @Transactional    
    def agregarPromocion(){
        log.info params
        def juicio = Juicio.get(params.promocionJuicioId as long)
        def fileNames = request.getFileNames()
        def listaDeArchivos = []
        def mapa
        fileNames.each{ fileName ->
            def uploadedFile = request.getFile(fileName)
            def fileLabel = ".${uploadedFile.originalFilename.split("\\.")[-1]}"
            log.info uploadedFile
            log.info "File name :"+ uploadedFile.originalFilename
            log.info "File size :"+ uploadedFile.size
            log.info "File label :"+ fileLabel
            InputStream inputStream = uploadedFile.inputStream
            mapa = [:]
            mapa.archivo = inputStream
            mapa.nombreDelArchivo = uploadedFile.originalFilename
            listaDeArchivos << mapa
        }
        def respuesta = juicioService.subirArchivo(listaDeArchivos, juicio.id)
        if(respuesta.exito){
            def promocion = new PromocionJuicio()
            promocion.juicio = juicio
            promocion.tipoDeParte = TipoDeParte.get(params.tipoDeParte.id as long)
            promocion.observaciones = params.observaciones
            promocion.fechaDePresentacion = new Date().parse('dd/MM/yyyy',params.fechaDePresentacion)
            promocion.fechaDePromocion = (params.fechaDePromocion ? new Date().parse('dd/MM/yyyy',params.fechaDePromocion) : null)
            promocion.resumenDeLaPromocion = params.resumenDeLaPromocion
            promocion.usuarioQueRegistro = springSecurityService.currentUser
            promocion.rutaArchivo = respuesta.idArchivo
            if(promocion.save(flush:true)){
                juicio.ultimaModificacion = new Date()
                juicio.personaQueModifico = springSecurityService.currentUser
                juicio.save(flash:true)
                flash.message = "La promocion se ha agregado correctamente"
                redirect action: "show", id: juicio?.id
            } else{
                flash.error = "Ha ocurrido un error al guardar la promocion."
                redirect action: "show", id: juicio?.id
            }
        } else{
            flash.error = "Ha ocurrido un error al subir el archivo del acuerdo."
            redirect action: "show", id: juicio?.id
        }
    }
    
    def agregarActor = {
        log.info params
        if(params.tipoDeActor){
            def idPersona 
            if(params.persona?.indexOf('[') != -1){
                idPersona = params.persona?.substring((params.persona.indexOf('[') + 1),params.persona.indexOf(']')) as long
            } else {
                idPersona = params.persona as long//?.substring((params.persona.indexOf('[') + 1),params.persona.indexOf(']'))
            }
            if(params.tipoDeActor == 'actor'){//Requiere validar el nombre
                log.info idPersona
                def resultado = juicioService.validarActor(idPersona, TipoDeParte.get(5))
                if(session.listaDeActores){
                    def yaExiste = juicioService.revisarLista(((session.listaDeActores)*.persona),idPersona)
                    if(!yaExiste){
                        session.listaDeActores << resultado
                    }
                } else {
                    def nuevaLista = []
                    nuevaLista << resultado
                    session.listaDeActores = nuevaLista
                }
                log.info session.listaDeActores
                render session.listaDeActores as JSON
            } else if(params.tipoDeActor == 'demandado'){
                log.info idPersona
                def resultado = juicioService.validarActor(idPersona, TipoDeParte.get(2))
                if(session.listaDeDemandados){
                    def yaExiste = juicioService.revisarLista(((session.listaDeDemandados)*.persona),idPersona)
                    if(!yaExiste){
                        session.listaDeDemandados << resultado
                    }
                } else {
                    def nuevaLista = []
                    nuevaLista << resultado
                    session.listaDeDemandados = nuevaLista
                }
                log.info session.listaDeDemandados
                render session.listaDeDemandados as JSON
            } else if(params.tipoDeActor == 'terceroInteresado'){//Requiere validar el nombre
                log.info idPersona
                def resultado = juicioService.validarActor(idPersona, TipoDeParte.get(3))
                if(session.listaDeTerceros){
                    def yaExiste = juicioService.revisarLista(((session.listaDeTerceros)*.persona),idPersona)
                    if(!yaExiste){
                        session.listaDeTerceros << resultado
                    }
                } else {
                    def nuevaLista = []
                    nuevaLista << resultado
                    session.listaDeTerceros = nuevaLista
                }
                log.info session.listaDeTerceros
                render session.listaDeTerceros as JSON
            } else if(params.tipoDeActor == 'denunciante'){//Requiere validar el nombre
                log.info idPersona
                def resultado = juicioService.validarActor(idPersona, TipoDeParte.get(6))
                if(session.listaDeDenunciantes){
                    def yaExiste = juicioService.revisarLista(((session.listaDeDenunciantes)*.persona),idPersona)
                    if(!yaExiste){
                        session.listaDeDenunciantes << resultado
                    }
                } else {
                    def nuevaLista = []
                    nuevaLista << resultado
                    session.listaDeDenunciantes = nuevaLista
                }
                log.info session.listaDeDenunciantes
                render session.listaDeDenunciantes as JSON
            } else if(params.tipoDeActor == 'probableResponsable'){
                log.info idPersona
                def resultado = juicioService.validarActor(idPersona, TipoDeParte.get(7))
                if(session.listaDeResponsables){
                    def yaExiste = juicioService.revisarLista(((session.listaDeResponsables)*.persona),idPersona)
                    if(!yaExiste){
                        session.listaDeResponsables << resultado
                    }
                } else {
                    def nuevaLista = []
                    nuevaLista << resultado
                    session.listaDeResponsables = nuevaLista
                }
                log.info session.listaDeResponsables
                render session.listaDeResponsables as JSON
            }
        } else {
            render "[error: 'Ocurrio un error']" as JSON
        }
    }
    
    def quitarActor = {
        log.info params
        if(params.tipoDeActor){
            def ids = params.persona?.tokenize(",")
            ids?.each {
                def idPersona = it as long//?.substring((params.persona.indexOf('[') + 1),params.persona.indexOf(']'))
                if(params.tipoDeActor == 'actor'){//Requiere validar el nombre
                    log.info idPersona
                    session.listaDeActores.removeAll { it.persona.id == idPersona }
                    log.info session.listaDeActores
                    render session.listaDeActores as JSON
                } else if(params.tipoDeActor == 'demandado'){
                    log.info idPersona
                    session.listaDeDemandados.removeAll { it.persona.id == idPersona }
                    log.info session.listaDeDemandados
                    render session.listaDeDemandados as JSON
                } else if(params.tipoDeActor == 'terceroInteresado'){//Requiere validar el nombre
                    log.info idPersona
                    session.listaDeTerceros.removeAll { it.persona.id == idPersona }
                    log.info session.listaDeTerceros
                    render session.listaDeTerceros as JSON
                } else if(params.tipoDeActor == 'denunciante'){//Requiere validar el nombre
                    log.info idPersona
                    session.listaDeDenunciantes.removeAll { it.persona.id == idPersona }
                    log.info session.listaDeDenunciantes
                    render session.listaDeDenunciantes as JSON
                } else if(params.tipoDeActor == 'probableResponsable'){
                    log.info idPersona
                    session.listaDeResponsables.removeAll { it.persona.id == idPersona }
                    log.info session.listaDeResponsables
                    render session.listaDeResponsables as JSON
                }
            }
        } else {
            render "[error: 'Ocurrio un error']" as JSON
        }
    }
    
    def eliminarLista = {
        log.info params
        if(params.tipoDeActor){
            if(params.tipoDeActor == 'actor'){//Requiere validar el nombre
                session.listaDeActores = null
                log.info session.listaDeActores
                def mapa = [:]
                mapa.listaVacia = true
                render mapa as JSON
            } else if(params.tipoDeActor == 'demandado'){
                session.listaDeDemandados = null
                log.info session.listaDeDemandados
                def mapa = [:]
                mapa.listaVacia = true
                render mapa as JSON
            } else if(params.tipoDeActor == 'terceroInteresado'){//Requiere validar el nombre
                session.listaDeTerceros = null
                log.info session.listaDeTerceros
                def mapa = [:]
                mapa.listaVacia = true
                render mapa as JSON
            } else if(params.tipoDeActor == 'denunciante'){//Requiere validar el nombre
                session.listaDeDenunciantes = null
                log.info session.listaDeDenunciantes
                def mapa = [:]
                mapa.listaVacia = true
                render mapa as JSON
            } else if(params.tipoDeActor == 'probableResponsable'){
                session.listaDeResponsables = null
                log.info session.listaDeResponsables
                def mapa = [:]
                mapa.listaVacia = true
                render mapa as JSON
            }
        } else {
            render "[error: 'Ocurrio un error']" as JSON
        }
    }
    
    def obtenerTiposDeProcedimiento = {
        log.info params
        def ambito = Ambito.get(params.ambito as long)
        def tiposDeProcedimiento = (TipoDeProcedimientoAmbito.findAllByAmbito(ambito))*.tipoDeProcedimiento
        def tmp = []
        tiposDeProcedimiento.each{
            if(it.materia.id == (params.materia as long)){
                tmp << it
            }
        }
        tiposDeProcedimiento = null
        tiposDeProcedimiento = tmp
        tiposDeProcedimiento = tiposDeProcedimiento.sort { it.nombre }
        log.info tiposDeProcedimiento
        render tiposDeProcedimiento as JSON
    }
    
    def obtenerTiposDeParte = {
        log.info params
        def tipoDeProcedimiento = TipoDeProcedimiento.get(params.tipoDeProcedimiento as long)
        def tiposDeParte = (TipoDeParteProcedimiento.findAllByTipoDeProcedimiento(tipoDeProcedimiento))*.tipoDeParte
        tiposDeParte = tiposDeParte.sort { it.nombre }
        render tiposDeParte as JSON
    }
    
    def obtenerEtapasProcesales = {
        log.info params
        def etapasProcesales = EtapaProcesal.obtenerEtapas(params.tipoDeProcedimiento as long)
        render etapasProcesales as JSON
    }
    
    def obtenerMunicipios = {//TODO adecuar para inmuebles
        log.info params
        def estado = (Delegacion.get(params.estado as long)).estado
        def materia = Materia.get(params.materia as long)
        def ambito = Ambito.get(params.ambito as long);
        def municipios =  (Municipio.executeQuery("SELECT am.municipio FROM AutoridadMunicipio am WHERE am.municipio.estado = :estado AND am.autoridad.materia = :materia AND am.autoridad.ambito = :ambito", [estado: estado, materia: materia, ambito: ambito])) as Set
        municipios = municipios.sort { it.nombre }
        render municipios as JSON
    }
    
    def obtenerJuzgados = {
        log.info params
        def municipio = Municipio.get(params.municipio as long)
        def materia = Materia.get(params.materia as long)
        def ambito = Ambito.get(params.ambito as long);
        def juzgados =  ((TipoDeAutoridad.executeQuery("SELECT am.autoridad FROM AutoridadMunicipio am WHERE am.municipio = :municipio AND am.autoridad.materia = :materia AND am.autoridad.ambito = :ambito", [municipio: municipio, materia: materia, ambito: ambito]))*.tipoDeAutoridad) as Set
        juzgados = juzgados.sort { it.nombre }
        render juzgados as JSON
    }
    
    def obtenerJuzgadosEdicion = {
        log.info "PARAMETROS -> " + params
        def municipio = Municipio.get(params.municipio as long)
        log.info "MUNICIPIO -> " + municipio
        def ambito = Ambito.findByNombre(params.ambito);
        log.info "AMBITO -> " + ambito + " * " + ambito.id
        def materia = Materia.findByNombre(params.materia)
        log.info "MATERIA -> " + materia + " * " + materia.id
        def juzgados =  ((TipoDeAutoridad.executeQuery("SELECT am.autoridad FROM AutoridadMunicipio am WHERE am.municipio = :municipio AND am.autoridad.materia = :materia AND am.autoridad.ambito = :ambito", [municipio: municipio, materia: materia, ambito: ambito]))*.tipoDeAutoridad) as Set
        juzgados = juzgados.sort { it.nombre }
        log.info "JUZGADOS -> " + juzgados 
        render juzgados as JSON
    }
    
    def obtenerAutoridadesEdicion = {
        log.info "PARAMETROS -> " + params
        def tipoDeAutoridad
        def autoridades
        if(params.juzgado) {
            tipoDeAutoridad = TipoDeAutoridad.get(params.juzgado as long)
            log.info "TIPO DE AUTORIDAD -> " + tipoDeAutoridad
        }
        def municipio = Municipio.get(params.municipio as long)
        log.info "MUNICIPIO -> " + municipio
        def ambito = Ambito.findByNombre(params.ambito);
        log.info "AMBITO -> " + ambito + " * " + ambito.id
        def materia = Materia.findByNombre(params.materia)
        log.info "MATERIA -> " + materia + " * " + materia.id
        if(params.juzgado) {
            autoridades = Autoridad.executeQuery("SELECT am.autoridad FROM AutoridadMunicipio am WHERE am.autoridad.activo = true AND am.municipio = :municipio AND am.autoridad.tipoDeAutoridad = :tipoDeAutoridad AND am.autoridad.materia = :materia AND am.autoridad.ambito = :ambito", [municipio: municipio, tipoDeAutoridad: tipoDeAutoridad, materia: materia, ambito: ambito])
        } else {
            def cadenaComplementaria
            if(ambito.id == 1 ){
                cadenaComplementaria = "PGR "
            } else if (ambito.id == 2){
                cadenaComplementaria = "PGJ "
            }
            autoridades = Autoridad.executeQuery("SELECT am.autoridad FROM AutoridadMunicipio am WHERE  am.autoridad.nombre like '" + cadenaComplementaria + "%' and am.autoridad.activo = true AND am.municipio = :municipio AND am.autoridad.materia = :materia AND am.autoridad.ambito = :ambito", [municipio: municipio, materia: materia, ambito: ambito])
        }
        autoridades = autoridades as Set
        autoridades = autoridades.sort { it.nombre }
        render autoridades as JSON
    }
    
    def obtenerAutoridades = {
        log.info params
        def tipoDeAutoridad
        def autoridades
        if(params.juzgado) {
            tipoDeAutoridad = TipoDeAutoridad.get(params.juzgado as long)
        }
        def municipio = Municipio.get(params.municipio as long)
        def materia = Materia.get(params.materia as long)
        def ambito = Ambito.get(params.ambito as long);
        if(params.juzgado) {
            autoridades = Autoridad.executeQuery("SELECT am.autoridad FROM AutoridadMunicipio am WHERE am.autoridad.activo = true AND am.municipio = :municipio AND am.autoridad.tipoDeAutoridad = :tipoDeAutoridad AND am.autoridad.materia = :materia AND am.autoridad.ambito = :ambito", [municipio: municipio, tipoDeAutoridad: tipoDeAutoridad, materia: materia, ambito: ambito])
        } else {
            def cadenaComplementaria
            if(ambito.id == 1 ){
                cadenaComplementaria = "PGR "
            } else if (ambito.id == 2){
                cadenaComplementaria = "PGJ "
            }
            autoridades = Autoridad.executeQuery("SELECT am.autoridad FROM AutoridadMunicipio am WHERE  am.autoridad.nombre like '" + cadenaComplementaria + "%' and am.autoridad.activo = true AND am.municipio = :municipio AND am.autoridad.materia = :materia AND am.autoridad.ambito = :ambito", [municipio: municipio, materia: materia, ambito: ambito])
        }
        autoridades = autoridades as Set
        autoridades = autoridades.sort { it.nombre }
        render autoridades as JSON
    }
    
    def obtenerTiposAsociados = {
        log.info params
        def prestacionReclamada = PrestacionReclamada.get(params.prestacionReclamada as long)
        def tiposAsociados = TipoAsociado.findAllByPrestacionReclamada(prestacionReclamada)
        tiposAsociados = tiposAsociados.sort { it.nombre }
        render tiposAsociados as JSON
    }
    
    def obtenerDelitos = {
        log.info params
        def tipoDeAsignacion = TipoDeAsignacion.get(params.tipoDeAsignacion as long)
        def delito = Delito.findAllByTipoDeAsignacion(tipoDeAsignacion)
        delito = delito.sort { it.nombre }
        render delito as JSON
    }
    
    def buscarActores = {
        log.info params
        def actores = []
        if(params.query){
            def resultado = []
            //resultado = Persona.executeQuery("from Persona p where ((p.nombre||' '||p.apellidoPaterno||' '||p.apellidoMaterno) = '"+params.query.toUpperCase()+"') or (p.nombre = '"+params.query.toUpperCase()+"') order by p.nombre")
            //resultado.addAll(Persona.executeQuery("from Persona p where ((p.nombre||' '||p.apellidoPaterno||' '||p.apellidoMaterno) like '%"+params.query.toUpperCase()+"%') or (p.nombre like '%"+params.query.toUpperCase()+"%') order by p.nombre"))
            resultado = Persona.executeQuery("from Persona p where ((p.nombre + ' ' + p.apellidoPaterno + ' ' + p.apellidoMaterno) = '"+params.query.toUpperCase()+"') or (p.nombre like '"+params.query.toUpperCase()+"') order by p.nombre")
            log.info ("Resultados Exactos: " + resultado)
            resultado.addAll(Persona.executeQuery("from Persona p where ((p.nombre + ' ' + p.apellidoPaterno + ' ' + p.apellidoMaterno) like '%"+params.query.toUpperCase()+"%') or (p.nombre like '%"+params.query.toUpperCase()+"%') order by p.nombre"))
            resultado = resultado as Set
            def map
            resultado.each{
                map = [:]
                map.value = "[" + it.id + "] - " + (it.nombre + ((it.apellidoPaterno) ? (" " +it.apellidoPaterno) : "") + ((it.apellidoMaterno) ? (" " + it.apellidoMaterno) : ""))
                map.id = it.id
                map.tokens = [it.nombre.toString(), it.apellidoPaterno.toString(),it.apellidoMaterno.toString()]
                actores << map
                map = null
            }
            log.info (actores)
        }
        render actores as JSON
    }
    
    def obtenerSiguientePregunta = {
        log.info params
        def respuesta = []
        respuesta = juicioService.obtenerSiguientePregunta(params.juicio, params.respuesta)
        log.info respuesta
        render(template: "/templates/workFlow", model: [respuesta: respuesta, juicioId: params.juicio])
    }
    
    def obtenerHistorialDelJuicio = {
        log.info params
        def respuesta
        def juicio = Juicio.get(params.juicio as long)
        respuesta = FlujoJuicio.findAllWhere(juicio: juicio)
        respuesta = respuesta.sort { it.fechaDeRespuesta }
        log.info respuesta
        render(template: "/templates/historialDelAsunto", model: [respuesta: respuesta, juicio: juicio])
    }
    
    def imprimitHistorialDelJuicio(){
        log.info params
        def juicio = Juicio.get(params.id as long)
        def file = juicioService.exportarSeguimiento(juicio)
        if (file){
            response.setContentType("application/octet-stream")
            response.setHeader("Content-disposition", "attachment;filename=\"Seguimiento_" + juicio.expedienteInterno + ".csv\"")
            response.outputStream << file.bytes
        } else {
            render "Error!"
        }
    }
    
    def obtenerArchivosDelJuicio = {
        log.info params
        def respuesta
        def juicio = Juicio.get(params.juicio as long)
        respuesta = ArchivoJuicio.findAllWhere(juicio: juicio)
        respuesta = respuesta.sort { it.fechaDeSubida }
        log.info respuesta
        render(template: "/templates/listaDeArchivos", model: [archivos: respuesta, juicio: juicio])
    }
    
    def obtenerBitacoraDelJuicio = {
        log.info params
        def respuesta
        def juicio = Juicio.get(params.juicio as long)
        respuesta = BitacoraDeJuicio.findAllWhere(juicio: juicio)
        respuesta = respuesta.sort { it.fechaDeMovimiento }
        log.info respuesta
        render(template: "/templates/bitacoraDelAsunto", model: [respuesta: respuesta])
    }
    
    def obtenerNotasDelJuicio = {
        log.info params
        def respuesta
        def juicio = Juicio.get(params.juicio as long)
        respuesta = NotaJuicio.findAllWhere(juicio: juicio)
        respuesta = respuesta.sort { it.fechaDeNota }
        respuesta = respuesta.reverse()
        log.info respuesta
        render(template: "/templates/notasDelJuicio", model: [respuesta: respuesta])
    }
    
    def obtenerDatosFinado = {
        log.info params
        def respuesta
        def juicio = Juicio.get(params.juicio as long)
        respuesta = NotaJuicio.findAllWhere(juicio: juicio)
        respuesta = respuesta.sort { it.fechaDeNota }
        respuesta = respuesta.reverse()
        log.info respuesta
        render(template: "/templates/detallesFinado", model: [respuesta: respuesta])
    }
    
    def mostrarTerminarJuicio = {
        log.info params
        def estadoDeJuicio
        def pagarSinTerminar = false
        def estado = params.estado as long
        def juicio = Juicio.get(params.juicio as long)
        def motivos = (MotivoDeTerminoMateria.findAllWhere(materia: juicio.materia))*.motivo
        if(estado == 0){
            pagarSinTerminar = true
            estadoDeJuicio = juicio.estadoDeJuicio
        } else {
            estadoDeJuicio = EstadoDeJuicio.get(params.estado as long)
        }
        motivos = motivos.sort { it.nombre }
        render(template: "/templates/terminarJuicio", model: [motivos: motivos, juicio: juicio.id, estadoDeJuicio: estadoDeJuicio, pagarSinTerminar: pagarSinTerminar])
    }
    
    def getAudiencias = {
        def datos = []
        def roles = springSecurityService?.authentication?.authorities*.authority
        def usuario = springSecurityService.currentUser
        def fechaInicio = new Date().parse('yyyy-MM-dd',params.start)
        def fechaFin = new Date().parse('yyyy-MM-dd',params.end)
        def audiencias = audienciaJuicioService.consultarAudiencias(usuario, roles, fechaInicio, fechaFin, params.tipo, params.juicioId)
        audiencias = audiencias.sort { it.fechaDeAudiencia }
        audiencias.each {
            def audiencia = [:]
            audiencia.id = it.id
            audiencia.title = it.juicio.expedienteInterno
            audiencia.start = it.fechaDeAudiencia
            audiencia.allDay = false
            if(it.cancelada && !it.reprogramada){
                audiencia.color = '#6E6E6E'
            } else if (it.reprogramada){
                audiencia.color = '#337ab7'
            } else if (it.resultado && it.acciones){
                audiencia.color = '#1ab394'
            } else {
                audiencia.color = '#f8ac59'
            }
            datos << audiencia
        }
        render datos as JSON
    }
    
    def obtenerPreguntasEtapa(){
        log.info params
        def respuesta = []
        def etapaProcesal = EtapaProcesal.get(params.etapaProcesal as long)
        def flujo = FlujoEtapaProcesal.withCriteria {
            tipoDeParte {
                'in'('id', (long[])([0,(params.tipoDeParte as long)]))
            }
            preguntaActual {
                eq('etapaProcesal',etapaProcesal)
            }
        }
        if(flujo){
            respuesta = flujo*.preguntaActual as Set
        }
        render respuesta as JSON
    }
    
    @Transactional    
    def subirArchivo(){
        log.info params
        def fileNames = request.getFileNames()
        def listaDeArchivos = []
        def mapa
        fileNames.each{ fileName ->
            def uploadedFile = request.getFile(fileName)
            def fileLabel = ".${uploadedFile.originalFilename.split("\\.")[-1]}"
            log.info uploadedFile
            log.info "File name :"+ uploadedFile.originalFilename
            log.info "File size :"+ uploadedFile.size
            log.info "File label :"+ fileLabel
            InputStream inputStream = uploadedFile.inputStream
            mapa = [:]
            mapa.archivo = inputStream
            mapa.nombreDelArchivo = uploadedFile.originalFilename
            listaDeArchivos << mapa
        }
        def respuesta = juicioService.subirArchivo(listaDeArchivos, params.archivoJuicioId)
        render respuesta as JSON
        /*if(respuesta.exito){
        log.info "EXITO"
        flash.message = "El archivo se ha agregado correctamente"
        redirect action: "show", id: params.archivoJuicioId
        } else {
        log.info "ERROR"
        flash.error = "Ha ocurrido un error al subir el archivo"
        redirect action: "show", id: params.archivoJuicioId
        }*/
    }
    
    def descargarArchivo(){
        log.info params
        if(params.id){
            def archivo = ArchivoJuicio.get(params.id as long)
            def file = new File(archivo.rutaArchivo+"/"+archivo.nombreArchivo)
            if (file.exists()){
                response.setContentType("application/octet-stream") // or or image/JPEG or text/xml or whatever type the file is
                response.setHeader("Content-disposition", "attachment;filename=\""+archivo.nombreArchivo+"\"")
                response.outputStream << file.bytes
            } else {
                render "Error!"
            }
        }
    }

    @Transactional 
    def eliminarArchivo(){
        log.info params
        def respuesta = [:]
        respuesta  = juicioService.eliminarArchivo(params.id)
        log.info respuesta
        render respuesta as JSON
    }
    
    def transferirJuicio(){
    }
    
    def reasignarJuicio(){
        
    }
    
    @Transactional
    def gestionDeAmparo(){
        log.info params
        def juicio = Juicio.get(params.amparoJuicioId as long)
        if(params.iniciarAmparo?.equals("true")){
            def fileNames = request.getFileNames()
            def listaDeArchivos = []
            def mapa
            fileNames.each{ fileName ->
                def uploadedFile = request.getFile(fileName)
                if(uploadedFile.size > 0) {
                    def fileLabel = ".${uploadedFile.originalFilename.split("\\.")[-1]}"
                    log.info uploadedFile
                    log.info "File name :"+ uploadedFile.originalFilename
                    log.info "File size :"+ uploadedFile.size
                    log.info "File label :"+ fileLabel
                    InputStream inputStream = uploadedFile.inputStream
                    mapa = [:]
                    mapa.archivo = inputStream
                    mapa.nombreDelArchivo = uploadedFile.originalFilename
                    listaDeArchivos << mapa
                }
            }
            def respuesta
            if(listaDeArchivos?.size() > 0){
                respuesta = juicioService.subirArchivo(listaDeArchivos, juicio.id)
            }
            def procesoAlterno = new ProcesoAlternoJuicio()
            juicio.procedimientoAlterno = true
            juicio.ultimaModificacion = new Date()
            juicio.personaQueModifico = springSecurityService.currentUser
            procesoAlterno.juicio = juicio
            procesoAlterno.tipoDeProcesoAlterno = TipoDeProcesoAlterno.get(params.tipoDeProcesoAlterno.id as long)
            procesoAlterno.estadoDeProceso =  EstadoDeProcesoAlterno.get(1)
            procesoAlterno.autoridadJudicial = Autoridad.get(params.autoridadJudicial.id)
            procesoAlterno.expediente = params.expedienteProcesoAlterno
            procesoAlterno.observaciones = params.observacionesProceso
            procesoAlterno.usuarioQueRegistro = springSecurityService.currentUser
            if(respuesta?.idArchivo){
                procesoAlterno.archivo = ArchivoJuicio.get(respuesta.idArchivo)
            }
            if(juicio.save(flush:true)){
                if(procesoAlterno.save(flush:true)){
                    flash.message = "El proceso alterno ha sido iniciado correctamente"
                    redirect action: "show", id: juicio.id
                } else {
                    flash.error = "Ha ocurrido un error al gestionar el proceso alterno"
                    redirect action: "show", id: juicio.id
                }
            } else {
                flash.error = "Ha ocurrido un error al gestionar el proceso alterno"
                redirect action: "show", id: juicio.id
            }
        } else if(params.terminarAmparo?.equals("true")){
            flash.message = "El amparo ha sido terminado correctamente"
            def procesoAlterno = ProcesoAlternoJuicio.findWhere(juicio:juicio, estadoDeProceso: EstadoDeProcesoAlterno.get(1))
            procesoAlterno.estadoDeProceso =  EstadoDeProcesoAlterno.get(2)
            procesoAlterno.fechaDeTermino = new Date()
            procesoAlterno.usuarioQueTermino = springSecurityService.currentUser
            procesoAlterno.notasFinales = params.notasFinales
            if(procesoAlterno.save(flush:true)){
                flash.message = "El proceso alterno ha sido iniciado correctamente"
                redirect action: "show", id: juicio.id
            } else {
                flash.error = "Ha ocurrido un error al gestionar el proceso alterno"
                redirect action: "show", id: juicio.id
            }
        }
    }
      
    def obtenerUsuariosDelegacion(){
        log.info params
        def delegacion = Delegacion.get(params.delegacion as long)
        def usuarios = Usuario.findAllWhere(delegacion: delegacion, tipoDeUsuario: 'INTERNO', enabled: true)
        usuarios = usuarios.sort { it.nombre }
        render usuarios as JSON
    }
    
    def mostrarListaCompleta(){
        log.info params
        def listaDePersonas
        def nombreLista
        def editar = false
        def usuario = springSecurityService.currentUser
        def queryPersonas = "SELECT a from ActorJuicio a WHERE a.juicio.id = " + params.idJuicio
        if(params.lista == "actores"){
            if(params.editar == "true") {
                nombreLista = "Actores"
                editar = true
            } else {
                nombreLista = "Actores/Denunciantes"
            }
            queryPersonas += " and a.tipoDeParte.id in (5,6) ORDER BY a.juicio.fechaDeCreacion ASC"
        } else if (params.lista == "demandados") {
            nombreLista = "Demandados/Probables Responsables"
            queryPersonas += " and a.tipoDeParte.id in (2,7) ORDER BY a.juicio.fechaDeCreacion ASC"
        }
        log.info queryPersonas
        listaDePersonas = ActorJuicio.executeQuery(queryPersonas)
        render(template: "/templates/listaCompletaDePersonas", model: [personas: listaDePersonas, titulo: nombreLista, editar: editar, usuario: usuario])
    }
    
    @Transactional
    def marcarDesistimiento(){
        log.info params
        def respuesta = [:]
        if(params.idPersona && params.idJuicio){
            def persona = Persona.get(params.idPersona as long)
            def juicio = Juicio.get(params.idJuicio as long)
            def actorJuicio = ActorJuicio.findWhere(persona: persona, juicio: juicio)
            if(actorJuicio){
                actorJuicio.haDesistido = true
                if(actorJuicio.save(flush:true)){
                    respuesta.exito = true
                } else {
                    respuesta.error = true
                    respuesta.mensaje = "Ocurrio un problema al actualizar el actor como desistido."
                }
            } else {
                respuesta.error = true
                respuesta.mensaje = "El actor indicado no está registrado en el juicio establecido."
            }
        } else {
            respuesta.error = true
            respuesta.mensaje = "No se recibio el actor ni juicio asociado."
        }
        render respuesta as JSON
    }
    
    def obtenerRespuestasDePregunta(){
        log.info params
        def respuesta = [:]
        def juicio = Juicio.get(params.juicioId as long)
        def preguntaAtendida = PreguntaEtapaProcesal.get(params.idPreguntaAtendida as long)
        def flujoJuicio = FlujoJuicio.findAllWhere(juicio: juicio, preguntaAtendida: preguntaAtendida)
        if(flujoJuicio){
            log.info "Tipo de Pregunta: " + preguntaAtendida.tipoDePregunta.id
            if(preguntaAtendida.tipoDePregunta.id != 1){
                flujoJuicio = flujoJuicio?.sort { it.fechaDeRespuesta }
                flujoJuicio = flujoJuicio.reverse()
                respuesta.pregunta = flujoJuicio?.getAt(0)
                respuesta.respuestas = juicioService.obtenerRespuestasPosibles(preguntaAtendida, juicio.tipoDeParte)
                if(preguntaAtendida.tipoDePregunta.elementoDeEntrada == "CHECKBOX"){
                    def listaCadenas = respuesta.pregunta.datoAuxiliar.tokenize(",")
                    respuesta.listaChecks = []
                    listaCadenas.each{
                        respuesta.listaChecks << (it as long)
                    }
                }
            } else {
                respuesta.error = true
                respuesta.mensaje = "Esta pregunta no puede ser editada porque puede causar inconsistencias en el seguimiento del flujo. Si desea cambiar el valor para esta pregunta realice un reproceso."
            }
            log.info "Respuestas: " + respuesta
        } else {
            respuesta.error = true
            respuesta.mensaje = "Esta pregunta no ha sido contestada, y por lo tanto no puede ser editada."
        }
        render(template: "/templates/editarPregunta", model: [respuesta: respuesta])
    }
    
    @Transactional
    def editarFlujoJuicio(){
        log.info params
        def respuestaDelUsuario
        def respuesta = [:]
        def flujoJuicio
        if(params.flujoJuicioId){
            flujoJuicio = FlujoJuicio.get(params.flujoJuicioId as long)
            def respuestas = []
            if (params.multiple) {   
                def paramsCheck = params.findAll{it.key.startsWith("respuestaCheck")}
                paramsCheck.each { key, value -> 
                    if(value.equals('on')) {
                        respuestas << RespuestaPregunta.get((key.minus('respuestaCheck')) as long)
                    }
                }
                respuestaDelUsuario = respuestas.getAt(0)
                params.respuesta = respuestaDelUsuario.id
            } else {   
                respuestaDelUsuario = RespuestaPregunta.get(params.respuesta as long)
            }
            if(!params.valorRespuesta && flujoJuicio.preguntaAtendida.tipoDePregunta.id != 1 && flujoJuicio.preguntaAtendida.tipoDePregunta.id != 3 && flujoJuicio.preguntaAtendida.tipoDePregunta.id != 5 ){
                params.valorRespuesta = "NO SE PROPORCIONO EL DATO"
            }
            def bitacoraDeWorkFlow = new BitacoraDeWorkFlow()
            bitacoraDeWorkFlow.juicio = flujoJuicio.juicio
            bitacoraDeWorkFlow.preguntaAtendida = flujoJuicio.preguntaAtendida
            bitacoraDeWorkFlow.usuario = springSecurityService.currentUser
            bitacoraDeWorkFlow.fechaDeMovimiento = new Date()
            bitacoraDeWorkFlow.respuestaAnterior = flujoJuicio.respuesta
            bitacoraDeWorkFlow.valorRespuestaAnterior = flujoJuicio.valorRespuesta
            bitacoraDeWorkFlow.datosAuxiliaresAnteriores = flujoJuicio.datoAuxiliar
            bitacoraDeWorkFlow.observaciones = flujoJuicio.observaciones
            if(bitacoraDeWorkFlow.save()) {
                flujoJuicio.respuesta = respuestaDelUsuario
                flujoJuicio.usuarioQueResponde = springSecurityService.currentUser
                //flujoJuicio.fechaDeRespuesta = new Date()
                flujoJuicio.valorRespuesta = (params.valorRespuesta ? params.valorRespuesta : (respuestas ? respuestas*.valorDeRespuesta.join(', ') : null))
                flujoJuicio.observaciones = params.observaciones
                flujoJuicio.datoAuxiliar = (params.datoAuxiliar ? params.datoAuxiliar : (respuestas ? respuestas*.id.join(',') : null))
                if(flujoJuicio.save()){
                    flujoJuicio.juicio.ultimaModificacion = new Date()
                    flujoJuicio.juicio.personaQueModifico = springSecurityService.currentUser
                    if(flujoJuicio.juicio.save()){
                        flash.message = "La pregunta ha sido actualizada correctamente."
                    } else {
                        flash.message = "Ocurrio un problema al actualizar los datos del juicio."
                    }
                } else {
                    flash.message = "Ocurrio un problema al actualizar la pregunta."
                }
            } else {
                flash.message = "Ocurrio un problema al registrar el movimiento en la bitácora"
            }
        } else {
            flash.message = "No se recibió la pregunta que debe ser editada. Intente nuevamente por favor."
        }
        redirect action: "show", id: flujoJuicio?.juicio.id
    }
    
    @Transactional    
    def agregarPago(){
        log.info params
        if(params.pagoJuicioId){
            def juicio = Juicio.get(params.pagoJuicioId as long)
            def pago = new PagoJuicioRezago()
            pago.montoDelPago = (params.montoDelPago as long)
            pago.numeroDePago = (params.numeroDePago as int)
            pago.juicio = juicio
            pago.fechaDelPago = (params.fechaDelPago ? new Date().parse('dd/MM/yyyy',params.fechaDelPago) : null)
            pago.usuarioQueRegistro = springSecurityService.currentUser
            if(pago.save(flush:true)){
                flash.message = "El pago se ha registrado correctamente."
            } else {
                flash.error = "Ocurrio un problema al registrar el pago. Verifique que ha llenado todos los campos e intente nuevamente."
            }
        }
        redirect action: "show", id: params.pagoJuicioId
    }
    
    def obtenerDatosMigrados(){
        log.info params
        def datosAdicionales
        if(params.juicio){
            def juicio = Juicio.get(params.juicio as long)
            datosAdicionales = SeguimientoLegalTracking.findAllWhere(juicio: juicio)
            datosAdicionales = datosAdicionales.sort{ it.fechaAlta }
        }
        render(template: "/templates/datosAdicionales", model: [datosAdicionales: datosAdicionales])
    }
    
    def archivoHistorico(){
        log.info params
        def usuario =  springSecurityService.currentUser
        def roles = springSecurityService.principal?.authorities*.authority
        log.info "Roles: " + roles
        if(usuario.tipoDeUsuario == "INTERNO"){
            def documentos = []
            if(roles.contains('ROLE_ADMIN') || roles.contains('ROLE_CONSULTA_HISTORICO_NACIONAL')){
                documentos.addAll(DocumentoArchivoHistorico.list())
            } else if(roles.contains('ROLE_CONSULTA_HISTORICO_LABORAL') || roles.contains('ROLE_CONSULTA_HISTORICO_CIVIL') || roles.contains('ROLE_CONSULTA_HISTORICO_PENAL')){
                if(roles.contains('ROLE_CONSULTA_HISTORICO_LABORAL')){
                    documentos.addAll(DocumentoArchivoHistorico.findAllWhere(delegacion: usuario.delegacion, materia: Materia.get(1)))
                }
                if(roles.contains('ROLE_CONSULTA_HISTORICO_CIVIL')){
                    documentos.addAll(DocumentoArchivoHistorico.findAllWhere(delegacion: usuario.delegacion, materia: Materia.get(2)))
                }
                if(roles.contains('ROLE_CONSULTA_HISTORICO_PENAL')){
                    documentos.addAll(DocumentoArchivoHistorico.findAllWhere(delegacion: usuario.delegacion, materia: Materia.get(3)))
                }
            } else if(roles.contains('ROLE_CONSULTA_HISTORICO_LABORAL_NACIONALIDAD') || roles.contains('ROLE_CONSULTA_HISTORICO_CIVIL_NACIONALIDAD') || roles.contains('ROLE_CONSULTA_HISTORICO_PENAL_NACIONALIDAD')){
                if(roles.contains('ROLE_CONSULTA_HISTORICO_LABORAL_NACIONALIDAD')){
                    documentos.addAll(DocumentoArchivoHistorico.findAllWhere(materia: Materia.get(1)))
                }
                if(roles.contains('ROLE_CONSULTA_HISTORICO_CIVIL_NACIONALIDAD')){
                    documentos.addAll(DocumentoArchivoHistorico.findAllWhere(materia: Materia.get(2)))
                }
                if(roles.contains('ROLE_CONSULTA_HISTORICO_PENAL_NACIONALIDAD')){
                    documentos.addAll(DocumentoArchivoHistorico.findAllWhere(materia: Materia.get(3)))
                }
            }
            [documentos: documentos]
        } else {
            render(status: 403)
        }
    }
    
    def descargarHistorico(){
        log.info params
        if(params.id){
            def archivo = DocumentoArchivoHistorico.get(params.id as long)
            def file = new File(archivo.rutaArchivo+archivo.nombreArchivo)
            if (file.exists()){
                response.setContentType("application/octet-stream") // or or image/JPEG or text/xml or whatever type the file is
                response.setHeader("Content-disposition", "attachment;filename=\""+archivo.nombreArchivo+"\"")
                response.outputStream << file.bytes
            } else {
                flash.error = "Ocurrio un problema al intentar descargar el archivo indicado."
                redirect action: "archivoHistorico"
            }
        }
    }
}
