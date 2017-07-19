package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Usuario
import mx.gox.infonavit.sicj.catalogos.TipoDeAudiencia

class AudienciaJuicio implements Serializable {

    Juicio juicio
    Date fechaDeAudiencia
    TipoDeAudiencia tipoDeAudiencia
    Usuario usuarioQueRegistro
    Date fechaDeRegistro
    String asistente
    boolean cancelada = false
    boolean reprogramada = false
    boolean reprogramacionPendiente = false
    String acciones
    String resultado
    String motivoDeReprogramacion
    
    static constraints = {
        juicio (nullable:false)
        fechaDeAudiencia (nullable:false)
        tipoDeAudiencia (nullable:false)
        usuarioQueRegistro (nullable:false)
        fechaDeRegistro (nullable:false)
        asistente (nullable:false)
        acciones (nullable:true)
        resultado (nullable:true)
        motivoDeReprogramacion (nullable:true)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_audiencia_juicio', params:[sequence:'audiencia_juicio_id_seq']
    }
    
    String toString () {
        "${tipoDeAudiencia} - ${fechaDeAudiencia}"
    }
    
    def AudienciaJuicio clonarAudiencia(){
        AudienciaJuicio.metaClass.getProperties().findAll(){it.getSetter()!=null}.inject(new AudienciaJuicio()){audienciaJuicio,metaProp->
            metaProp.setProperty(audienciaJuicio,metaProp.getProperty(this))
            audienciaJuicio
        }
    }
}
