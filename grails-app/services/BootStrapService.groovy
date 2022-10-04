import org.apache.commons.codec.digest.DigestUtils
import org.codehaus.groovy.grails.commons.GrailsApplication
import javax.sql.DataSource

class BootStrapService {

    Integer prefSettingRank = 0
    Integer sysSettingRank = 0
    GrailsApplication grailsApplication
    DataSource dataSource
    AdminService adminService

    private sql() {
        new groovy.sql.Sql(dataSource.connection)
    }

    def patch(appVersion, name, description, Closure patchCode) {
        boolean applyable = false
        def grailsAppVersion = grailsApplication.metadata['app.version']
        def appV = versionMap(grailsAppVersion)
        def pAppV = versionMap(appVersion)
        if (appV.majorVersion >= pAppV.majorVersion && appV.midVersion >= pAppV.midVersion && appV.minorVersion >= pAppV.minorVersion) {
            applyable = true
        }
        def dbPatch = new DatabasePatch('name': name, 'description': description, 'majorVersion': pAppV.majorVersion, 'midVersion': pAppV.midVersion, 'minorVersion': pAppV.minorVersion)
        def found = DatabasePatch.find(dbPatch)
        boolean alreadyApplied = (null != found)
        log.info("Patch $dbPatch${applyable ? '' : ' *not*'} applyable to $grailsAppVersion ${alreadyApplied ? 'but' : 'and *not*'} already applied${alreadyApplied ? ' at ' + found.dateCreated : ''}")
        if (applyable && !alreadyApplied) {
            try {
                patchCode()
                dbPatch.save()
                log.info("APPLIED PATCH : $dbPatch")
            } catch (t) {
                log.error("!!!!!!!!!!!!!!!!!! FAILED TO APPLY PATCH : $dbPatch !!!!!!!!!!!!!!!!!!, ${t.localizedMessage}", t)
            }
        }
    }

    private _l(val) {
        try {
            val as Long
        } catch (exz) {
            val
        }
    }

    def versionMap(appVersion) {
        def appVersionArray = appVersion?.split("\\.")
        return [majorVersion: _l(appVersionArray.size() > 0 ? appVersionArray[0] : 0l),
                midVersion  : _l(appVersionArray.size() > 1 ? appVersionArray[1] : 0l),
                minorVersion: _l(appVersionArray.size() > 2 ? appVersionArray[2] : 0l)]
    }

    def execDdl(sql) { dataSource.connection.prepareStatement(sql).executeUpdate(); log.info("[$sql] OK ") }

    def updateData(sql) {
        def rowsUpdated = dataSource.connection.prepareStatement(sql).executeUpdate();
        log.info("[$sql] : $rowsUpdated rows updated.")
    }

    def setting(key, type, defvalue, categ) {
        setting(key, type, defvalue, categ, null)
    }

    def delsetting(key) {
        updateData("delete from setting where key='$key' and user is not null")
    }

    def delsyssetting(key) {
        updateData("delete from setting where key='$key' and user is null")
    }

    def setting(key, type, defvalue, categ, permission, shouldNotChange = true) {
        def permDefinition = permission?.split("/")
        def permissionTarget = permDefinition ? permDefinition[0] : null
        def permissionActions = permDefinition ? permDefinition[1] : null
        prefSettingRank++
        JsecUser.withTransaction {
            JsecUser.list().each { user ->
                def s = new Setting(key: key, settingType: type, value: defvalue, defaultValue: defvalue, user: user, category: categ, permissionType: permissionTarget ? 'EtudePerm' : null, permissionTarget: permissionTarget, permissionActions: permissionActions, rank: prefSettingRank)
                def dbSett = Setting.findByKeyAndUser(key, user)
                if (dbSett) {
                    s.value = shouldNotChange ? (dbSett.value ?: s.value) : s.value
                    if (dbSett.properties != s.properties) {
                        dbSett.properties = s.properties
                        dbSett.save()
                        log.trace("updated setting [$key] type: ${type}, default value : [$defvalue], permissionTarget : $permissionTarget, permissionActions : $permissionActions")
                    }
                } else {
                    if (s.validate()) {
                        s.save()
                        log.trace("created setting [$key] type: ${type}, default value : [$defvalue], permissionTarget : $permissionTarget, permissionActions : $permissionActions")
                    } else {
                        s.errors.allErrors.each {
                            log.error("Unable to create setting [${key}] type: ${type}, default value : [$defvalue] \n $it")
                        }
                    }
                }
            }
        }
    }

    def syssetting(key, defvalue, categ) {
        syssetting(key, (defvalue instanceof Boolean ? "boolean" : "string"), defvalue, categ)
    }

    def syssetting(key, type, defvalue, categ) {
        sysSettingRank++
        def s = new Setting(key: key, settingType: type, value: defvalue, defaultValue: defvalue, category: categ, rank: sysSettingRank)
        def dbSett = Setting.findByKey(key)
        if (!dbSett) {
            if (s.validate()) {
                s.save()
                log.trace("created setting [$key] type: ${type}, default value : [$defvalue]")
            } else {
                s.errors.allErrors.each {
                    log.error("Unable to create setting [${key}] type: ${type}, default value : [$defvalue] \n $it")
                }
            }
        }
    }

    def favorite(num, name, url, shouldNotChange = true) {
        setting("favoris.${num}.check", 'boolean', 'true', '03-favoris/accueil', 'Dossier/Liste', shouldNotChange)
        setting("favoris.${num}.name", 'string', name, '03-favoris/accueil', 'Dossier/Liste', shouldNotChange)
        setting("favoris.${num}", 'url', "${ParamUtils.root(false)}${url}&title=${name}", '03-favoris/accueil', 'Dossier/Liste', shouldNotChange)
    }

    def roleDef(roleName) {
        def role = JsecRole.findByName(roleName)
        if (!role) {
            role = new JsecRole(name: roleName)
            role.save()
        }
        return role
    }

    def perm(permName) {
        def roles = JsecRole.list()
        def p1 = JsecPermission.findByType('EtudePerm')
        roles.each { role ->
            log.info("Checking [$role] on target [$permName]...")
            if (!JsecRolePermissionRel.findByTargetAndRole(permName, role)) {
                log.warn("------------>NOT FOUND")
                def actions = (role.name == 'Maitre' ? 'Liste,Consultation,Creation,Modification,Suppression,ModificationMasse,RapportDetail,RapportSynthese' : 'Aucune')
                if (new JsecRolePermissionRel(role: role, permission: p1, target: permName, actions: actions).save()) {
                    log.warn("------------>Added permission [$actions]")
                }
            }
        }
    }

    def permDef(role, target, actions) {
        def p = JsecPermission.findByType('EtudePerm')
        if (!JsecRolePermissionRel.findByTargetAndRole(target, role)) {
            log.warn(">>>>------------>NOT FOUND")
            if (new JsecRolePermissionRel(role: role, permission: p, target: target, actions: actions).save()) {
                log.warn("------------>Added permission [$actions]")
            }
        }
    }

    def populateSettingsForUsers() {
        favorite(1, 'En Conservation', '/dossier/list?typeEcriture=21')
        favorite(2, 'En Enregistrement', '/dossier/list?typeEcriture=19')
        favorite(3, 'En Cours', '/dossier/list?etat=1')
        favorite(10, 'En Instance CF', '/dossier/list?typeEcriture=19&exclude=21&minAmount=200&notTag=dossiers.tag1')
        favorite(11, 'En Instance IR/PF', '/dossier/list?typeEcriture=19&exclude=14&minAmount=200&notTag=dossiers.tag2&isNull=operation')
    }

    def bootStrapJobs() {
        adminService.listJobs("userjobs").each { entry ->
            entry.value.eachWithIndex { it, i ->
                def jobName = it.name
                def cronExp = grailsApplication.config."${it.name}Config".cron ?: "0 0 ${10 + i} ? * *"
                def jobEnabled = grailsApplication.config."${it.name}Config".enabled
                if (!(jobEnabled instanceof Boolean)) {
                    jobEnabled = true
                }
                syssetting("${it.name}.enabled", "boolean", "${jobEnabled}", "04-maintenance/${jobName}")
                syssetting("${it.name}.cron", cronExp, "04-maintenance/${jobName}")
                if (Setting.syssetting("${it.name}.enabled") == true) {
                    adminService.schedule(it.name)
                }
                log.info("JOB ${it.name}.enabled : ${jobEnabled}, CRON : ${cronExp}")
            }
        }
    }

    def jobParam(jobName, varName, defaultValue) {
        syssetting("${jobName}.${varName}", defaultValue, "04-maintenance/${jobName}")
    }

    def trad(key, value, label) {
        ParamUtils.trad(key, value, label)
    }

    def createDefaultData() {
        log.info("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        log.info(">>>>>>!!!!!!!!!                  DEFAULT DATA")
        log.info("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        def maitreRole = roleDef("Maitre")
        def defaultUser = (System.getenv('ETUDE_DEF_USR') ?: 'mouwatik')
        def admin = JsecUser.findByUsername(defaultUser)
        log.info("DEFAULT USER NOT FOUND!!!")
        if (!admin && !JsecUser.count()) {
            def pwd = (System.getenv('ETUDE_DEF_PWD') ?: 'changeit')
            admin = new JsecUser(username: defaultUser, passwordHash: DigestUtils.shaHex(pwd))
            admin.save()
            new JsecUserRoleRel(user: admin, role: maitreRole).save()
        }
        def p1 = JsecPermission.findByType('EtudePerm')
        if (!p1) {
            p1 = new JsecPermission(type: 'EtudePerm', possibleActions: '*')
            p1.save()
        }
        log.info("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        log.info("<<<<<<              DEFAULT DATA")
        log.info("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    }
}

