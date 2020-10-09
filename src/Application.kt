package ch.exasoft.geoservices

import io.ktor.application.*
import io.ktor.response.*
import io.ktor.request.*
import io.ktor.routing.*
import io.ktor.http.*
import freemarker.cache.*
import io.ktor.freemarker.*
import io.ktor.features.*
import org.slf4j.event.*
import io.ktor.gson.*
import io.ktor.client.*
import io.ktor.client.engine.apache.*
import io.ktor.client.features.json.*
import io.ktor.client.request.*
import io.ktor.client.features.logging.*
import io.ktor.client.features.BrowserUserAgent
import io.ktor.http.content.resources
import io.ktor.http.content.static

fun main(args: Array<String>): Unit = io.ktor.server.tomcat.EngineMain.main(args)


@Suppress("unused") // Referenced in application.conf
@kotlin.jvm.JvmOverloads
fun Application.module(testing: Boolean = false) {
    install(FreeMarker) {
        templateLoader = ClassTemplateLoader(this::class.java.classLoader, "templates")
    }

    install(CallLogging) {
        level = Level.INFO
        filter { call -> call.request.path().startsWith("/") }
    }

//    install(CORS) {
//        method(HttpMethod.Options)
//        method(HttpMethod.Put)
//        method(HttpMethod.Delete)
//        method(HttpMethod.Patch)
//        header(HttpHeaders.Authorization)
//        header("MyCustomHeader")
//        allowCredentials = true
//        anyHost() // @TODO: Don't do this in production if possible. Try to limit it.
//    }

    install(DefaultHeaders) {
        header("X-Engine", "Ktor") // will send this header with each response
    }

    install(HSTS) {
        includeSubDomains = true
    }

    install(ContentNegotiation) {
        gson {
        }
    }

    val client = HttpClient(Apache) {
        install(JsonFeature) {
            serializer = GsonSerializer()
        }
        install(Logging) {
            level = LogLevel.HEADERS
        }
        BrowserUserAgent() // install default browser-like user-agent
        // install(UserAgent) { agent = "some user agent" }
    }

    val LATITUDEWGS84 = "latitudeWGS84"
    val LONGITUDEWGS84 = "longitudeWGS84"
    val ALTITUDEWGS84 = "altitudeWGS84"
    val ALTITUDEAGL = "altitudeAGL"
    val ALTITUDELN02 = "altitudeLn02"

    routing {

        get("/") {
            val model = mapOf(
                    LONGITUDEWGS84 to ""
                    , LATITUDEWGS84 to ""
                    , ALTITUDEWGS84 to ""
                    , ALTITUDEAGL to ""
                    , ALTITUDELN02 to ""
                    , "hasResult" to false
                    , "hasError" to false
                    , "hasResultRTK" to false
                    , "hasErrorRTK" to false
            )
            call.respond(FreeMarkerContent("index.ftl", model, ""))
        }

        post("/convert") {
            val formData: Parameters = call.receiveParameters()
            val longitudeWGS84 = formData[LONGITUDEWGS84]
            val latitudeWGS84 = formData[LATITUDEWGS84]
            val altitudeWGS84 = formData[ALTITUDEWGS84] ?: ""
            val altitudeAGL = formData[ALTITUDEAGL] ?: ""
            val altitudeLn02 = formData[ALTITUDELN02] ?: ""

            var hasError = false
            val altitudeDiff = try {
                val gcsLv95 = client.get<GeoCoordinateSystemLv95>("""http://geodesy.geo.admin.ch/reframe/wgs84tolv95?easting=$longitudeWGS84&northing=$latitudeWGS84&format=json""")
                val height = client.get<Height>("https://api3.geo.admin.ch/rest/services/height?easting=${gcsLv95.easting}&northing=${gcsLv95.northing}")
                val altitude: Float = height.height.toFloat().plus(altitudeAGL.toFloat())
                val gcsLv95Converted = client.get<GeoCoordinateSystemLv95>("http://geodesy.geo.admin.ch/reframe/lv95towgs84?easting=${gcsLv95.easting}&northing=${gcsLv95.northing}&altitude=$altitude&format=json")
                gcsLv95Converted.altitude.toFloat().minus(altitudeWGS84.toFloat())
            } catch (e: Exception) {
                log.warn("fehler", e)
                hasError = true
            }


            call.respond(FreeMarkerContent("index.ftl", mapOf(
                    LONGITUDEWGS84 to longitudeWGS84
                    , LATITUDEWGS84 to latitudeWGS84
                    , ALTITUDEWGS84 to altitudeWGS84
                    , ALTITUDEAGL to altitudeAGL
                    , ALTITUDELN02 to altitudeLn02
                    , "altitudeDiff" to altitudeDiff
                    , "hasResult" to true
                    , "hasError" to hasError
                    , "hasResultRTK" to false
                    , "hasErrorRTK" to false
            ), ""))
        }

        post("/convert1") {
            val formData: Parameters = call.receiveParameters()
            val longitudeWGS84 = formData[LONGITUDEWGS84]
            val latitudeWGS84 = formData[LATITUDEWGS84]
            val altitudeWGS84 = formData[ALTITUDEWGS84] ?: ""
            val altitudeAGL = formData[ALTITUDEAGL] ?: ""
            val altitudeLn02 = formData[ALTITUDELN02] ?: ""

            var hasError = false
            val altitudeDiff = try {
                val gcsLv95 = client.get<GeoCoordinateSystemLv95>("""http://geodesy.geo.admin.ch/reframe/wgs84tolv95?easting=$longitudeWGS84&northing=$latitudeWGS84&format=json""")
                val height = altitudeLn02
                val altitude: Float = height.toFloat().plus(altitudeAGL.toFloat())
                val gcsLv95Converted = client.get<GeoCoordinateSystemLv95>("http://geodesy.geo.admin.ch/reframe/lv95towgs84?easting=${gcsLv95.easting}&northing=${gcsLv95.northing}&altitude=$altitude&format=json")
                gcsLv95Converted.altitude.toFloat().minus(altitudeWGS84.toFloat())
            } catch (e: Exception) {
                log.warn("fehler", e)
                hasError = true
            }


            call.respond(FreeMarkerContent("index.ftl", mapOf(
                    LONGITUDEWGS84 to longitudeWGS84
                    , LATITUDEWGS84 to latitudeWGS84
                    , ALTITUDEWGS84 to altitudeWGS84
                    , ALTITUDEAGL to altitudeAGL
                    , ALTITUDELN02 to altitudeLn02
                    , "altitudeDiff" to altitudeDiff
                    , "hasResult" to true
                    , "hasError" to hasError
                    , "hasResultRTK" to false
                    , "hasErrorRTK" to false
            ), ""))
        }

        post("/convertRTK") {
            val formData: Parameters = call.receiveParameters()
            val longitudeWGS84 = formData[LONGITUDEWGS84]
            val latitudeWGS84 = formData[LATITUDEWGS84]

            var hasError = false
            val altitudeDiff = try {
                val gcsLv95 = client.get<GeoCoordinateSystemLv95>("""http://geodesy.geo.admin.ch/reframe/wgs84tolv95?easting=$longitudeWGS84&northing=$latitudeWGS84&format=json""")
                val height = client.get<Height>("https://api3.geo.admin.ch/rest/services/height?easting=${gcsLv95.easting}&northing=${gcsLv95.northing}")
                val altitude: Float = height.height.toFloat();
                val gcsLv95Converted = client.get<GeoCoordinateSystemLv95>("http://geodesy.geo.admin.ch/reframe/ln02tobessel?easting=${gcsLv95.easting}&northing=${gcsLv95.northing}&altitude=$altitude&format=json")
                altitude.minus(gcsLv95Converted.altitude.toFloat())
            } catch (e: Exception) {
                log.warn("fehler", e)
                hasError = true
            }


            call.respond(FreeMarkerContent("index.ftl", mapOf(
                    LONGITUDEWGS84 to longitudeWGS84
                    , LATITUDEWGS84 to latitudeWGS84
                    , ALTITUDEWGS84 to ""
                    , ALTITUDEAGL to ""
                    , ALTITUDELN02 to ""
                    , "altitudeDiff" to altitudeDiff
                    , "hasResult" to false
                    , "hasError" to false
                    , "hasResultRTK" to true
                    , "hasErrorRTK" to hasError
            ), ""))
        }

        install(StatusPages) {
            exception<AuthenticationException> { _ ->
                call.respond(HttpStatusCode.Unauthorized)
            }
            exception<AuthorizationException> { _ ->
                call.respond(HttpStatusCode.Forbidden)
            }

        }

        // Static feature. Try to access `/static/ktor_logo.svg`
        static("/static") {
            resources("static")
        }


    }
}


class AuthenticationException : RuntimeException()
class AuthorizationException : RuntimeException()

data class GeoCoordinateSystemLv95(val easting: String, val northing: String, val altitude: String)
data class Height(val height: String)
//data class Model(val altitudeAGL: String, val altitudeWGS84: String, val latitudeWGS84: String, val longitudeWGS84: String)

