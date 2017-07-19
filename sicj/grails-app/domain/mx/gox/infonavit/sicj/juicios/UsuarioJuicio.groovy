package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Usuario

class UsuarioJuicio implements Serializable {

    Usuario usuario
    Juicio juicio
    Date fechaDeRegistro
    
    static constraints = {
        usuario (nullable:false)
        juicio (nullable:false)
        fechaDeRegistro (nullable:false)
    }
    
    static mapping = {
        id composite : ['usuario', 'juicio']
    }
}
