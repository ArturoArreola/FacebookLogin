package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Delegacion
import mx.gox.infonavit.sicj.admin.Despacho
import mx.gox.infonavit.sicj.admin.Proveedor
import mx.gox.infonavit.sicj.admin.Region
import mx.gox.infonavit.sicj.admin.Usuario
import mx.gox.infonavit.sicj.catalogos.Ambito
import mx.gox.infonavit.sicj.catalogos.Autoridad
import mx.gox.infonavit.sicj.catalogos.EstadoDeJuicio
import mx.gox.infonavit.sicj.catalogos.EtapaProcesal
import mx.gox.infonavit.sicj.catalogos.FormaDePago
import mx.gox.infonavit.sicj.catalogos.Materia
import mx.gox.infonavit.sicj.catalogos.MotivoDeTermino
import mx.gox.infonavit.sicj.catalogos.Municipio
import mx.gox.infonavit.sicj.catalogos.PatrocinadorDelJuicio
import mx.gox.infonavit.sicj.catalogos.PrestadorDeServicio
import mx.gox.infonavit.sicj.catalogos.Provision
//import mx.gox.infonavit.sicj.catalogos.TipoDeMoneda
import mx.gox.infonavit.sicj.catalogos.TipoDeParte
import mx.gox.infonavit.sicj.catalogos.TipoDeProcedimiento
import mx.gox.infonavit.sicj.catalogos.TipoDeReproceso

import mx.gox.infonavit.sicj.catalogos.PreguntaEtapaProcesal

class Juicio implements Serializable {

    Materia materia
    EstadoDeJuicio estadoDeJuicio
    Delegacion delegacion
    Despacho despacho
    Proveedor proveedor
    Region region
    Ambito ambito
    TipoDeProcedimiento tipoDeProcedimiento
    TipoDeParte tipoDeParte
    PatrocinadorDelJuicio patrocinadoDelJuicio
    Provision provision
    PrestadorDeServicio prestadorDeServicio
    Autoridad autoridad
    Municipio municipioAutoridad
    Usuario creadorDelCaso
    Usuario responsableDelJuicio
    EtapaProcesal etapaProcesal
    String expedienteInterno
    String expediente
    Date fechaDeCreacion = new Date()
    String antecedentes
    Date fechaRD
    boolean finado = false
    String nombreDelFinado
    String numeroSeguroSocialDelFinado
    String rfcDelFinado
    boolean cantidadDemandada = false
    long monto 
    //TipoDeMoneda tipoDeMoneda
    PreguntaEtapaProcesal ultimaPregunta
    Date fechaDeTermino
    Date fechaRegistroDeTermino
    MotivoDeTermino motivoDeTermino
    Usuario terminadoPor
    boolean juicioPagado
    long cantidadPagada = 0
    FormaDePago formaDePago
    boolean procedimientoAlterno = false
    String subprocuraduria
    String unidadEspecializada
    String fiscalia
    String mesaInvestigadora
    String agencia
    String numeroDeCausaPenal
    String otraInstancia
    Date ultimaModificacion
    Usuario personaQueModifico
    TipoDeReproceso tipoDeReproceso
    String juzgadoAsignado
    String acreditado
    String anioDelCredito
    String notario
    Delegacion radicacionDelJuicio
    Date ultimaActualizacionWorkflow
    Usuario ultimaPersonaQueActualizoWorkflow
    Usuario responsableDelDespacho
    Usuario gerenteJuridico
    
    static constraints = {
        materia (nullable:false)
        estadoDeJuicio (nullable:false)
        delegacion (nullable:false)
        despacho (nullable:false)
        proveedor (nullable: true)
        region (nullable:true)
        ambito (nullable:false)
        tipoDeProcedimiento (nullable:false)
        tipoDeParte (nullable:false)
        patrocinadoDelJuicio (nullable:true)
        prestadorDeServicio (nullable:true)
        creadorDelCaso (nullable:false)
        etapaProcesal (nullable:true)
        expedienteInterno (nullable:false)
        expediente (nullable:false)
        fechaDeCreacion (nullable:false)
        antecedentes (nullable:true)
        fechaRD (nullable:false)
        provision (nullable:false)
        autoridad (nullable:true)
        municipioAutoridad (nullable:true)
        nombreDelFinado (nullable:true)
        numeroSeguroSocialDelFinado (nullable:true)
        rfcDelFinado (nullable:true)
        //tipoDeMoneda (nullable:true)
        responsableDelJuicio (nullable:true)
        ultimaPregunta (nullable:true)
        fechaDeTermino (nullable:true)
        fechaRegistroDeTermino (nullable:true)
        motivoDeTermino (nullable:true)
        formaDePago (nullable:true)
        subprocuraduria (nullable:true)
        unidadEspecializada (nullable:true)
        fiscalia (nullable:true)
        mesaInvestigadora (nullable:true)
        agencia (nullable:true)
        otraInstancia (nullable:true)
        numeroDeCausaPenal (nullable:true)
        ultimaModificacion (nullable:true)
        personaQueModifico (nullable:true)
        terminadoPor (nullable:true)
        tipoDeReproceso (nullable:true)
        juzgadoAsignado (nullable:true)
        acreditado (nullable: true)
        anioDelCredito (nullable: true)
        notario (nullable: true)
        radicacionDelJuicio (nullable: true)
        ultimaActualizacionWorkflow (nullable:true)
        ultimaPersonaQueActualizoWorkflow (nullable:true)
        responsableDelDespacho (nullable:true)
        gerenteJuridico (nullable:true)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_juicio', params:[sequence:'juicio_id_seq']
    }
    
    String toString () {
        "${expedienteInterno}" + "/" + "${delegacion}"
    }
}
