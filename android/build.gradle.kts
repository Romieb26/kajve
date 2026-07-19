plugins {
    id("org.jetbrains.kotlin.android") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// El plugin screen_protector no fija explícitamente el jvmTarget de su
// tarea Kotlin, y Gradle lo infiere del JDK que ejecuta Gradle (21 en
// este equipo) en vez de los 17 con los que ya compila su propio javac,
// produciendo "Inconsistent JVM Target Compatibility". Se corrige solo
// para ese módulo (por nombre) para no arriesgar a otros plugins que ya
// compilan bien con su propia configuración (ej. share_plus, que fija
// Java 1.8 explícitamente).
gradle.projectsEvaluated {
    project(":screen_protector").tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>()
        .configureEach {
            compilerOptions {
                jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
            }
        }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
