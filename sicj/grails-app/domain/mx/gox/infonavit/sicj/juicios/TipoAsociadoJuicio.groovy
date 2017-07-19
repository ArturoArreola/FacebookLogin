package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.catalogos.TipoAsociado

class TipoAsociadoJuicio implements Serializable {

    TipoAsociado tipoAsociado
    Juicio juicio
    
    static constraints = {
        tipoAsociado (nullable:false)
        juicio (nullable:false)
    }
    
    static mapping = {
        id composite : ['tipoAsociado', 'juicio']
    }
}
