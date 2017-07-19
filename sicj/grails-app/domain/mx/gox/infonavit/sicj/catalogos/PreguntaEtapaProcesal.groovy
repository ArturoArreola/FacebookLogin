package mx.gox.infonavit.sicj.catalogos

class PreguntaEtapaProcesal implements Serializable{

    EtapaProcesal etapaProcesal
    TipoDePregunta tipoDePregunta
    String textoPregunta
    boolean obligatoria = true
    boolean requiereSubirArchivo = false
    boolean requiereAudiencia = false
    
    static constraints = {
        etapaProcesal (nullable:false)
        tipoDePregunta (nullable:false)
        textoPregunta (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_pregunta_etapa_procesal', params:[sequence:'pregunta_etapa_procesal_id_seq']
    }
    
    String toString () {
        "${textoPregunta}"
    }
}
