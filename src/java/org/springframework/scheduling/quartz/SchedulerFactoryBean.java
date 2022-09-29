//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package org.springframework.scheduling.quartz;

import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.impl.RemoteScheduler;
import org.quartz.impl.SchedulerRepository;
import org.quartz.impl.StdSchedulerFactory;
import org.quartz.simpl.SimpleThreadPool;
import org.quartz.spi.JobFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.BeanNameAware;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.SmartLifecycle;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.core.io.support.PropertiesLoaderUtils;
import org.springframework.scheduling.SchedulingException;
import org.springframework.util.CollectionUtils;

import javax.sql.DataSource;
import java.io.IOException;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.Executor;

public class SchedulerFactoryBean extends SchedulerAccessor implements FactoryBean<Scheduler>, BeanNameAware, ApplicationContextAware, InitializingBean, DisposableBean, SmartLifecycle {
    public static final String PROP_THREAD_COUNT = "org.quartz.threadPool.threadCount";
    public static final int DEFAULT_THREAD_COUNT = 2;
    private static final ThreadLocal<ResourceLoader> configTimeResourceLoaderHolder = new ThreadLocal();
    private static final ThreadLocal<Executor> configTimeTaskExecutorHolder = new ThreadLocal();
    private static final ThreadLocal<DataSource> configTimeDataSourceHolder = new ThreadLocal();
    private static final ThreadLocal<DataSource> configTimeNonTransactionalDataSourceHolder = new ThreadLocal();
    private Class<?> schedulerFactoryClass = StdSchedulerFactory.class;
    private String schedulerName;
    private Resource configLocation;
    private Properties quartzProperties;
    private Executor taskExecutor;
    private DataSource dataSource;
    private DataSource nonTransactionalDataSource;
    private Map schedulerContextMap;
    private ApplicationContext applicationContext;
    private String applicationContextSchedulerContextKey;
    private JobFactory jobFactory;
    private boolean jobFactorySet = false;
    private boolean autoStartup = true;
    private int startupDelay = 0;
    private int phase = 2147483647;
    private boolean exposeSchedulerInRepository = false;
    private boolean waitForJobsToCompleteOnShutdown = false;
    private Scheduler scheduler;

    public SchedulerFactoryBean() {
    }

    public static ResourceLoader getConfigTimeResourceLoader() {
        return (ResourceLoader)configTimeResourceLoaderHolder.get();
    }

    public static Executor getConfigTimeTaskExecutor() {
        return (Executor)configTimeTaskExecutorHolder.get();
    }

    public static DataSource getConfigTimeDataSource() {
        return (DataSource)configTimeDataSourceHolder.get();
    }

    public static DataSource getConfigTimeNonTransactionalDataSource() {
        return (DataSource)configTimeNonTransactionalDataSourceHolder.get();
    }

    public void setSchedulerFactoryClass(Class schedulerFactoryClass) {
        if(schedulerFactoryClass != null && SchedulerFactory.class.isAssignableFrom(schedulerFactoryClass)) {
            this.schedulerFactoryClass = schedulerFactoryClass;
        } else {
            throw new IllegalArgumentException("schedulerFactoryClass must implement [org.quartz.SchedulerFactory]");
        }
    }

    public void setSchedulerName(String schedulerName) {
        this.schedulerName = schedulerName;
    }

    public void setConfigLocation(Resource configLocation) {
        this.configLocation = configLocation;
    }

    public void setQuartzProperties(Properties quartzProperties) {
        this.quartzProperties = quartzProperties;
    }

    public void setTaskExecutor(Executor taskExecutor) {
        this.taskExecutor = taskExecutor;
    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public void setNonTransactionalDataSource(DataSource nonTransactionalDataSource) {
        this.nonTransactionalDataSource = nonTransactionalDataSource;
    }

    public void setSchedulerContextAsMap(Map schedulerContextAsMap) {
        this.schedulerContextMap = schedulerContextAsMap;
    }

    public void setApplicationContextSchedulerContextKey(String applicationContextSchedulerContextKey) {
        this.applicationContextSchedulerContextKey = applicationContextSchedulerContextKey;
    }

    public void setJobFactory(JobFactory jobFactory) {
        this.jobFactory = jobFactory;
        this.jobFactorySet = true;
    }

    public void setAutoStartup(boolean autoStartup) {
        this.autoStartup = autoStartup;
    }

    public boolean isAutoStartup() {
        return this.autoStartup;
    }

    public void setPhase(int phase) {
        this.phase = phase;
    }

    public int getPhase() {
        return this.phase;
    }

    public void setStartupDelay(int startupDelay) {
        this.startupDelay = startupDelay;
    }

    public void setExposeSchedulerInRepository(boolean exposeSchedulerInRepository) {
        this.exposeSchedulerInRepository = exposeSchedulerInRepository;
    }

    public void setWaitForJobsToCompleteOnShutdown(boolean waitForJobsToCompleteOnShutdown) {
        this.waitForJobsToCompleteOnShutdown = waitForJobsToCompleteOnShutdown;
    }

    public void setBeanName(String name) {
        if(this.schedulerName == null) {
            this.schedulerName = name;
        }

    }

    public void setApplicationContext(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
    }

    public void afterPropertiesSet() throws Exception {
        if(this.dataSource == null && this.nonTransactionalDataSource != null) {
            this.dataSource = this.nonTransactionalDataSource;
        }

        if(this.applicationContext != null && this.resourceLoader == null) {
            this.resourceLoader = this.applicationContext;
        }

        SchedulerFactory schedulerFactory = (SchedulerFactory)BeanUtils.instantiateClass(this.schedulerFactoryClass);
        this.initSchedulerFactory(schedulerFactory);
        if(this.resourceLoader != null) {
            configTimeResourceLoaderHolder.set(this.resourceLoader);
        }

        if(this.taskExecutor != null) {
            configTimeTaskExecutorHolder.set(this.taskExecutor);
        }

        if(this.dataSource != null) {
            configTimeDataSourceHolder.set(this.dataSource);
        }

        if(this.nonTransactionalDataSource != null) {
            configTimeNonTransactionalDataSourceHolder.set(this.nonTransactionalDataSource);
        }

        try {
            this.scheduler = this.createScheduler(schedulerFactory, this.schedulerName);
            this.populateSchedulerContext();
            if(!this.jobFactorySet && !(this.scheduler instanceof RemoteScheduler)) {
                this.jobFactory = new AdaptableJobFactory();
            }

            if(this.jobFactory != null) {
                if(this.jobFactory instanceof SchedulerContextAware) {
                    ((SchedulerContextAware)this.jobFactory).setSchedulerContext(this.scheduler.getContext());
                }

                this.scheduler.setJobFactory(this.jobFactory);
            }
        } finally {
            if(this.resourceLoader != null) {
                configTimeResourceLoaderHolder.remove();
            }

            if(this.taskExecutor != null) {
                configTimeTaskExecutorHolder.remove();
            }

            if(this.dataSource != null) {
                configTimeDataSourceHolder.remove();
            }

            if(this.nonTransactionalDataSource != null) {
                configTimeNonTransactionalDataSourceHolder.remove();
            }

        }

        this.registerListeners();
        this.registerJobsAndTriggers();
    }

    private void initSchedulerFactory(SchedulerFactory schedulerFactory) throws SchedulerException, IOException {
        if(!(schedulerFactory instanceof StdSchedulerFactory)) {
            if(this.configLocation != null || this.quartzProperties != null || this.taskExecutor != null || this.dataSource != null) {
                throw new IllegalArgumentException("StdSchedulerFactory required for applying Quartz properties: " + schedulerFactory);
            }
        } else {
            Properties mergedProps = new Properties();
            if(this.resourceLoader != null) {
                mergedProps.setProperty("org.quartz.scheduler.classLoadHelper.class", ResourceLoaderClassLoadHelper.class.getName());
            }

            if(this.taskExecutor != null) {
                mergedProps.setProperty("org.quartz.threadPool.class", LocalTaskExecutorThreadPool.class.getName());
            } else {
                mergedProps.setProperty("org.quartz.threadPool.class", SimpleThreadPool.class.getName());
                mergedProps.setProperty("org.quartz.threadPool.threadCount", Integer.toString(2));
            }

            if(this.configLocation != null) {
                if(this.logger.isInfoEnabled()) {
                    this.logger.info("Loading Quartz config from [" + this.configLocation + "]");
                }

                PropertiesLoaderUtils.fillProperties(mergedProps, this.configLocation);
            }

            CollectionUtils.mergePropertiesIntoMap(this.quartzProperties, mergedProps);
            if(this.dataSource != null) {
                mergedProps.put("org.quartz.jobStore.class", LocalDataSourceJobStore.class.getName());
            }

            if(this.schedulerName != null) {
                mergedProps.put("org.quartz.scheduler.instanceName", this.schedulerName);
            }

            ((StdSchedulerFactory)schedulerFactory).initialize(mergedProps);
        }
    }

    protected Scheduler createScheduler(SchedulerFactory schedulerFactory, String schedulerName) throws SchedulerException {
        Thread currentThread = Thread.currentThread();
        ClassLoader threadContextClassLoader = currentThread.getContextClassLoader();
        boolean overrideClassLoader = this.resourceLoader != null && !this.resourceLoader.getClassLoader().equals(threadContextClassLoader);
        if(overrideClassLoader) {
            currentThread.setContextClassLoader(this.resourceLoader.getClassLoader());
        }

        Scheduler var11;
        try {
            SchedulerRepository repository = SchedulerRepository.getInstance();
            synchronized(repository) {
                Scheduler existingScheduler = schedulerName != null?repository.lookup(schedulerName):null;
                Scheduler newScheduler = schedulerFactory.getScheduler();
                if(newScheduler == existingScheduler) {
                    throw new IllegalStateException("Active Scheduler of name \'" + schedulerName + "\' already registered " + "in Quartz SchedulerRepository. Cannot create a new Spring-managed Scheduler of the same name!");
                }

                if(!this.exposeSchedulerInRepository) {
                    SchedulerRepository.getInstance().remove(newScheduler.getSchedulerName());
                }

                var11 = newScheduler;
            }
        } finally {
            if(overrideClassLoader) {
                currentThread.setContextClassLoader(threadContextClassLoader);
            }

        }

        return var11;
    }

    private void populateSchedulerContext() throws SchedulerException {
        if(this.schedulerContextMap != null) {
            this.scheduler.getContext().putAll(this.schedulerContextMap);
        }

        if(this.applicationContextSchedulerContextKey != null) {
            if(this.applicationContext == null) {
                throw new IllegalStateException("SchedulerFactoryBean needs to be set up in an ApplicationContext to be able to handle an \'applicationContextSchedulerContextKey\'");
            }

            this.scheduler.getContext().put(this.applicationContextSchedulerContextKey, this.applicationContext);
        }

    }

    protected void startScheduler(final Scheduler scheduler, final int startupDelay) throws SchedulerException {
        if(startupDelay <= 0) {
            this.logger.info("Starting Quartz Scheduler now");
            scheduler.start();
        } else {
            if(this.logger.isInfoEnabled()) {
                this.logger.info("Will start Quartz Scheduler [" + scheduler.getSchedulerName() + "] in " + startupDelay + " seconds");
            }

            Thread schedulerThread = new Thread() {
                public void run() {
                    try {
                        Thread.sleep((long)(startupDelay * 1000));
                    } catch (InterruptedException var3) {
                        ;
                    }

                    if(SchedulerFactoryBean.this.logger.isInfoEnabled()) {
                        SchedulerFactoryBean.this.logger.info("Starting Quartz Scheduler now, after delay of " + startupDelay + " seconds");
                    }

                    try {
                        scheduler.start();
                    } catch (SchedulerException var2) {
                        throw new SchedulingException("Could not start Quartz Scheduler after delay", var2);
                    }
                }
            };
            schedulerThread.setName("Quartz Scheduler [" + scheduler.getSchedulerName() + "]");
            schedulerThread.setDaemon(true);
            schedulerThread.start();
        }

    }

    public Scheduler getScheduler() {
        return this.scheduler;
    }

    public Scheduler getObject() {
        return this.scheduler;
    }

    public Class<? extends Scheduler> getObjectType() {
        return this.scheduler != null?this.scheduler.getClass():Scheduler.class;
    }

    public boolean isSingleton() {
        return true;
    }

    public void start() throws SchedulingException {
        if(this.scheduler != null) {
            try {
                this.startScheduler(this.scheduler, this.startupDelay);
            } catch (SchedulerException var2) {
                throw new SchedulingException("Could not start Quartz Scheduler", var2);
            }
        }

    }

    public void stop() throws SchedulingException {
        if(this.scheduler != null) {
            try {
                this.scheduler.standby();
            } catch (SchedulerException var2) {
                throw new SchedulingException("Could not stop Quartz Scheduler", var2);
            }
        }

    }

    public void stop(Runnable callback) throws SchedulingException {
        this.stop();
        callback.run();
    }

    public boolean isRunning() throws SchedulingException {
        if(this.scheduler != null) {
            try {
                return !this.scheduler.isInStandbyMode();
            } catch (SchedulerException var1) {
                return false;
            }
        } else {
            return false;
        }
    }

    public void destroy() throws SchedulerException {
        this.logger.info("Shutting down Quartz Scheduler");
        this.scheduler.shutdown(this.waitForJobsToCompleteOnShutdown);
    }
}
