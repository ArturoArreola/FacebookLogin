<%@ page import="com.kosmos.prueba.Informacion" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main">
        <g:set var="entityName" value="${message(code: 'informacion.label', default: 'Informacion')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <form id="formRedesSociales" method="POST" action="test">
            <input type="hidden" id="datosFb" name="datosFb"/>
        </form>
        <a href="#list-informacion" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
                </ul>
        </div>
        <br/>
        <br/>
        <br/>
        <div id="fb-root"></div>
        <script>
            function statusChangeCallback(response) {
                console.log('statusChangeCallback');
                console.log(response);

                if (response.status === 'connected') {
                    testAPI();
                } else {
                    document.getElementById('status').innerHTML = 'Please log into this app.';
                }
            }

            function checkLoginState() {
                FB.getLoginStatus(function(response) {
                    statusChangeCallback(response);
                });
            }

            window.fbAsyncInit = function() {
                FB.init({
                appId      : '441418322902632',
                cookie     : true,  // enable cookies to allow the server to access the session
                xfbml      : true,  // parse social plugins on this page
                version    : 'v2.8' // use graph api version 2.8
                });

                FB.getLoginStatus(function(response) {
                statusChangeCallback(response);
                });
            };

            (function(d, s, id) {
                var js, fjs = d.getElementsByTagName(s)[0];
                if (d.getElementById(id)) return;
                js = d.createElement(s); js.id = id;
                js.src = "//connect.facebook.net/en_US/sdk.js";
                fjs.parentNode.insertBefore(js, fjs);
                }(document, 'script', 'facebook-jssdk'));

                function testAPI() {
                console.log('Welcome!  Fetching your information.... ');
                FB.api('/me?fields=id,name,picture,birthday,education,email,first_name,gender,last_name,middle_name,work,locale,hometown', function(response) {
                    console.log('-> ID de la persona: ' + response.id);
                    console.log('-> Nombre Completo de la persona: ' + response.name);
                    console.log('-> Primer nombre de la persona: ' + response.first_name);
                    console.log('-> Segundo nombre de la persona: ' + response.middle_name);
                    console.log('-> Apellido de la persona: ' + response.last_name);
                    console.log('-> Email de la persona: ' + response.email);
                    console.log('-> Género de la persona: ' + response.gender);
                    console.log('-> Fecha de nacimiento de la persona: ' + response.birthday);
                    console.log('-> Ubicación de la persona: ' + response.locale);
                    //console.log('-> Relaciones de la persona: ' + response.relationship_status);
                    //console.log('-> Lugar de la persona: ' + response.location);
                    console.log('-> Lugar de la persona: ' + response.hometown);
                    alert('First name: ' + response.first_name + '\nLast name: ' + response.last_name + '\nEmail: ' + response.email + '\nGender: ' + response.gender + '\nBirthday: ' + response.birthday + '\nHometown: ' + response.hometown);
                    document.getElementById('status').innerHTML =
                    'GRACIAS POR INICIAR SESIÓN, ' + response.name + '!';
                });
            }
        </script>
        <fb:login-button size="xlarge" scope="public_profile,user_friends,email,user_birthday" onlogin="checkLoginState();">
            Continue with Facebook
        </fb:login-button>
        <br/>
        <br/>
        <div id="status">
        </div>
        <br/>
        <br/>
        <br/>
        <hr>
        <div class="borderTopResumen">
            <div class="marginTop20 marginBottom20">
                <form id="formLogin" method="POST" action="test">
                    <input type="hidden" name="origen" value="noLogin" />
                    <input type="hidden" name="paso" value="1" />
                </form>
                <!--button id="submitLogin">EMPEZAR MI SOLICITUD</button-->
            </div>
        </div>
    </body>
    <script>
        window.fbAsyncInit = function() {
        FB.init({
        appId      : '441418322902632',
        cookie     : true,
        xfbml      : true,
        version    : 'v2.8'
        });
        FB.AppEvents.logPageView();
        console.log('ENTRO SEGUNDO SCRIPT');
        FB.login(function (response) {
        if (response.authResponse) {
        console.log('Login Sccess!!!.... ');
        //Parametros de Busqueda FB
        FB.api('/me?fields=id,name,picture,birthday,education,email,first_name,gender,last_name,middle_name,work,location', function (response) {
        $("#datosFb").val(JSON.stringify(response));
        $("#formRedesSociales").submit();
        console.log('Good to see you, ' + response.name + '.');
        });
        } else {
        console.log('Proceso de Login cancelado.....');
        }
        });
        };

        (function(d, s, id){
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) {return;}
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/en_US/sdk.js";
        fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));
    </script>
    <script type="text/javascript">
        function fbLogin(){
        console.log('HOLA');
        }
    </script>
</html>
