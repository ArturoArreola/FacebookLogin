package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Usuario

class NotaJuicio implements Serializable{

    String nota
    Juicio juicio
    Date fechaDeNota
    Usuario usuario
    
    static constraints = {
        nota (nullable:false)
        juicio (nullable:false)
        fechaDeNota (nullable:false)
        usuario (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_nota_juicio', params:[sequence:'nota_juicio_id_seq']
    }
    
    String toString () {
        "${nota}"
    }
}
