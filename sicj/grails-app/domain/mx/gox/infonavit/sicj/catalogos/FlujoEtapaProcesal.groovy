package mx.gox.infonavit.sicj.catalogos

class FlujoEtapaProcesal implements Serializable{

    PreguntaEtapaProcesal preguntaActual
    PreguntaEtapaProcesal siguientePregunta
    RespuestaPregunta respuesta
    TipoDeParte tipoDeParte
    boolean primerPregunta
    boolean concluyeEtapa
    boolean concluyeProcedimiento
    
    static constraints = {
        preguntaActual (nullable:false)
        siguientePregunta (nullable:false)
        respuesta (nullable:false)
        tipoDeParte (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_flujo_etapa_procesal', params:[sequence:'flujo_etapa_procesal_id_seq']
    }
    
    String toString () {
        "${preguntaActual}"
    }
}
