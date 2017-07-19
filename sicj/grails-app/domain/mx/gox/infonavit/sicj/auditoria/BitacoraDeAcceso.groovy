package mx.gox.infonavit.sicj.auditoria

class BitacoraDeAcceso implements Serializable{

    String username
    Date fechaDeEvento
    String tipoDeEvento
    String estado

    static constraints = {
        estado(inList: ["Fallida", "Exitosa"])
        fechaDeEvento(blank:false)
        username(blank:false)
        tipoDeEvento(inList:["Login","Logout"])
    }
    
    static mapping = {
        id generator : 'sequence', column : 'id_bitacora_de_acceso', params:[sequence:'bitacora_de_acceso_id_seq']
    }
}
