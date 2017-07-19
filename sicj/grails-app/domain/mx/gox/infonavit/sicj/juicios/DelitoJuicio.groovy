package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.catalogos.Delito

class DelitoJuicio implements Serializable {

    Delito delito
    Juicio juicio
    
    static constraints = {
        delito (nullable:false)
        juicio (nullable:false)
    }
    
    static mapping = {
        id composite : ['delito', 'juicio']
    }
}
