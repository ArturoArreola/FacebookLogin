package mx.gox.infonavit.sicj.catalogos

class TipoDeProcedimientoAmbito implements Serializable {

    Ambito ambito
    TipoDeProcedimiento tipoDeProcedimiento
    
    static constraints = {
        ambito (nullable:false)
        tipoDeProcedimiento (nullable:false)
    }
    
    static mapping = {
        id composite : ['ambito', 'tipoDeProcedimiento']
    }
}
