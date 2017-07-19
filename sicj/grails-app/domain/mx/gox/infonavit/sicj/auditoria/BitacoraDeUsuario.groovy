package mx.gox.infonavit.sicj.auditoria

import mx.gox.infonavit.sicj.admin.Usuario

class BitacoraDeUsuario implements Serializable{
    
    Usuario usuarioModificado
    Usuario usuarioQueModifica
    Date fechaDeEvento
    String tipoDeEvento
    String campoModificado
    String valorAnterior
    String valorNuevo

    static constraints = {
        usuarioModificado (nullable: false)
        usuarioQueModifica (nullable: false)
        fechaDeEvento (nullable: false)
        tipoDeEvento (blank: false)
        campoModificado (blank: false)
        valorAnterior (blank: false)
        valorNuevo (blank: false)
    }
    
    static mapping = {
        id generator : 'sequence', column : 'id_bitacora_de_usuario', params:[sequence:'bitacora_de_usuario_id_seq']
    }
}
