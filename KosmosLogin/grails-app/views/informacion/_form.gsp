<%@ page import="com.kosmos.prueba.Informacion" %>



<div class="fieldcontain ${hasErrors(bean: informacionInstance, field: 'informacion', 'error')} required">
	<label for="informacion">
		<g:message code="informacion.informacion.label" default="Informacion" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="informacion" required="" value="${informacionInstance?.informacion}"/>

</div>

