allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 1. Xác định thư mục build mong muốn (E:\Flutter\todo_list\build)
val flutterBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(flutterBuildDir)

subprojects {
    // 2. Lấy đường dẫn tuyệt đối của project gốc (E:\Flutter\todo_list)
    val rootDirPath = rootProject.projectDir.absolutePath
    val projectPath = project.projectDir.absolutePath

    // 3. CHỈ chuyển hướng nếu module đó nằm TRONG thư mục project của bạn
    // Nếu là thư viện từ Pub Cache (ổ C), hãy để nó dùng thư mục build mặc định
    if (projectPath.startsWith(rootDirPath)) {
        val newSubprojectBuildDir: Directory = flutterBuildDir.dir(project.name)
        project.layout.buildDirectory.value(newSubprojectBuildDir)
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
