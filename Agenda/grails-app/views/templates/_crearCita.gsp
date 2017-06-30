<%@ page import="demo.Responsable" %>
<g:if test="${flash.message}">
    <div class="message" role="status">${flash.message}</div>
</g:if>
<g:hasErrors bean="${this.agenda}">
    <ul class="errors" role="alert">
        <g:eachError bean="${this.agenda}" var="error">
            <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
        </g:eachError>
    </ul>
</g:hasErrors>

<div class="modal-dialog modal-lg">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span> <span class="sr-only">close</span></button>
            <h3 align ="center" class="modal-title" >
                Datos de la nueva cita
            </h3>
            <g:form action="save">
                <div class="modal-body">
                    <fieldset class="form">
                        <label for="responsable">Responsable</label>
                        <g:select property="responsable" id="responsable" name ="responsable.id" from="${Responsable.list()}" optionKey ="id" value="${agenda.responsable?.id}" />
                        </br>
                        <f:field bean = "agenda" property = "lugar"/>
                        <f:field bean = "agenda" property = "descripcion"/>
                        </br>
                        <label for="nicio_cita">Inicio de la nueva cita</label>
                        <g:datePicker name="inicio_cita" noSelection="['':'-Choose-']" years="${1916..2016}"/>
                        </br>
                        <label for="fin_cita">Fin de la nueva cita</label>
                        <g:datePicker name ="fin_cita" noSelection="['':'-Choose-']"  years="${1916..2016}"/>
                </fieldset>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-dismiss="modal">   
                        Cancelar
                    </button>
                    <g:actionSubmit class="btn btn-primary" action="save" value="Guardar" />
                </div>
            </g:form>
        </div>
    </div>
</div>



               