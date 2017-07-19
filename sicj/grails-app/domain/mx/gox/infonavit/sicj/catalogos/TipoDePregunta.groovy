package mx.gox.infonavit.sicj.catalogos

class TipoDePregunta implements Serializable{

    String elementoDeEntrada
    String expresionRegular
    boolean requiereValidacion = true
    
    static constraints = {
        elementoDeEntrada (nullable:false)
        expresionRegular (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_tipo_de_pregunta', params:[sequence:'tipo_de_pregunta_id_seq']
    }
    
    String toString () {
        "${elementoDeEntrada}"
    }
}
