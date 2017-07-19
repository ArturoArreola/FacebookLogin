package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Usuario
import mx.gox.infonavit.sicj.catalogos.PreguntaEtapaProcesal
import mx.gox.infonavit.sicj.catalogos.RespuestaPregunta

class FlujoJuicio implements Serializable{

    PreguntaEtapaProcesal preguntaAtendida
    RespuestaPregunta respuesta
    Juicio juicio
    Usuario usuarioQueResponde
    Date fechaDeRespuesta
    String valorRespuesta
    String observaciones
    String datoAuxiliar
    boolean vigente = true
    
    static constraints = {
        preguntaAtendida (nullable:false)
        usuarioQueResponde (nullable:false)
        respuesta (nullable:false)
        fechaDeRespuesta (nullable:false)
        valorRespuesta (nullable:true)
        juicio (nullable:false)
        observaciones (nullable:true)
        datoAuxiliar (nullable:true)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_flujo_juicio', params:[sequence:'flujo_juicio_id_seq']
    }
    
    String toString () {
        "P:${preguntaAtendida} R: ${respuesta}"
    }
}
