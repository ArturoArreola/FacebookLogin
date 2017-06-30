package demo

class Responsable 
{   
    String nombre
    String apellido
    String email

    static constraints = 
    {
    //        id_responsable()
    //        nombre()
    //        apellido()
    //        email()        
    }
    String toString()
    {
       "${nombre}"
    } 
}