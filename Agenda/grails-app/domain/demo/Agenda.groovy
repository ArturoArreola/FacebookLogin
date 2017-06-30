package demo

class Agenda implements Cloneable
{
    String titulo
    Boolean todo_el_dia
    String descripcion
    Date inicio_cita
    Date fin_cita
    Boolean cambio_cita
    String lugar
    Responsable responsable
    Integer numero_cita
    
    static constraints = 
    {
        inicio_cita nullable: true
        fin_cita nullable: true
        cambio_cita nullable: true
        numero_cita nullable: true
    }
}