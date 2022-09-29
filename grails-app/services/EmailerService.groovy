import groovy.text.Template
import groovy.text.SimpleTemplateEngine

import org.springframework.mail.MailException
import org.springframework.mail.MailSender
import org.springframework.mail.SimpleMailMessage
import org.springframework.mail.javamail.MimeMessageHelper
import org.codehaus.groovy.grails.commons.ApplicationHolder

import javax.mail.internet.MimeMessage
import javax.mail.internet.InternetAddress;

/**
* Simple service for sending emails.
*
* Work is planned in the Grails roadmap to implement first-class email
* support, so there's no point in making this code any more sophisticated
*/
class EmailerService {

	boolean transactional = false

	SimpleMailMessage mailMessage // a "prototype" email instance

	MailSender mailSender
	
	MailPropertiesBean mailPropertiesBean

	def setupFromDatabase(){
		def account = System.env.ETUDE_EMAIL_ACCOUNT ?: "AKIAJ7ORYFVVO4AQXYTA"
		def password = System.env.ETUDE_EMAIL_PASSWORD ?: "BJQ+8tDeB/qoVK/j7ZbBHANlBU/x1MYaQyXSf4F6x5lY"
		if (account && password){
			mailSender.username =  account
			mailSender.password = password
			def senderName = "\"${Setting.syssetting('etude')}\"<backup@apps.arkilog.ma>"
			mailMessage.from = senderName
			mailPropertiesBean.from = senderName
		} else {
			throw new IllegalStateException("La messagerie n'est pas configur&eacute;e")
		}
	}
   // If next line is commented in, this service fails to be loaded by grails, as every grails-artefact already has a 'log' property
   // Logger log = Logger.getLogger(this.class.name)

   def sendEmail(mail) throws MailException {
		setupFromDatabase()
       MimeMessage mimeMessage = mailSender.createMimeMessage()
       MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
       helper.setFrom(mailPropertiesBean.getFrom());
       helper.setTo(getInternetAddresses(mail.to));
       helper.setSubject(mail.subject);
       helper.setText(mail.text, true);
		if(mail.attachments) {
			mail.attachments.each{
				helper.addAttachment(it.key,it.value)
			}
		}
       if(mail.bcc) helper.setBcc(getInternetAddresses(mail.bcc));
       if(mail.cc) helper.setCc(getInternetAddresses(mail.cc));
       try {
           log.info("About to send message [${mail.subject}] to: ${mail.to}")
		   mailSender.send(mimeMessage)
           log.info("Message [${mail.subject}] sent to: ${mail.to}")
       } catch (MailException ex) {
           log.error("Failed to send email", ex)
       }
   }

   private InternetAddress[] getInternetAddresses(String emails){
	def split = {it,sep-> Arrays.asList(it?.split(sep) ?: []).collect{it.trim()}.findAll{it && it != ""}}
	def emailList = split(emails, ",")
					.collect{split(it, ";")}.flatten()
		getInternetAddresses(emailList.unique())
   }
   private InternetAddress[] getInternetAddresses(List emails){
       InternetAddress[] mailAddresses = new InternetAddress[emails.size()];
	   emails.eachWithIndex {mail, i ->
	   		mailAddresses[i] = new InternetAddress(mail)
	   }
       return mailAddresses;
   }	
	String bindTemplate(templateName, binding){
		def tplFile = ApplicationHolder.application.parentContext.getResource( 
				File.separator + "WEB-INF" + File.separator + templateName +".gtpl"
				).file
		def template = new SimpleTemplateEngine().createTemplate(tplFile).make(binding)
		template.toString()
	}
}