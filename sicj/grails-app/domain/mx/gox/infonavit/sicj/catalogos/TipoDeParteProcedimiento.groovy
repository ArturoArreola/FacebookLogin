package mx.gox.infonavit.sicj.catalogos

class TipoDeParteProcedimiento implements Serializable {

    TipoDeParte tipoDeParte
    TipoDeProcedimiento tipoDeProcedimiento
    
    static constraints = {
        tipoDeParte (nullable:false)
        tipoDeProcedimiento (nullable:false)
    }
    
    static mapping = {
        id composite : ['tipoDeParte', 'tipoDeProcedimiento']
    }
}
