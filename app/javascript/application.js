// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "./src/jquery"
import * as bootstrap from "bootstrap"

console.log("Hello Rails!")
$(document).ready(function(){
    alert("reloaded")
})