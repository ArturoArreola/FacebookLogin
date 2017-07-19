package mx.gox.infonavit.sicj.auditoria

import mx.gox.infonavit.sicj.admin.Usuario
import mx.gox.infonavit.sicj.catalogos.EstadoDeJuicio
import mx.gox.infonavit.sicj.juicios.Juicio

class BitacoraDeJuicio implements Serializable{

    Juicio juicio
    EstadoDeJuicio estadoDeJuicio
    Usuario usuario
    Date fechaDeMovimiento
    String observaciones
    
    static constraints = {
        juicio (nullable:false)
        estadoDeJuicio (nullable:false)
        usuario (nullable:false)
        fechaDeMovimiento (nullable:false)
        observaciones (nullable:true)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_bitacora_de_juicio', params:[sequence:'bitacora_de_juicio_id_seq']
    }
}
