/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */
package config

import (
	"context"
	"fmt"
	"log"
	"path/filepath"
	"time"

	"github.com/getsentry/sentry-go"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"gopkg.in/ini.v1"
)

const (
	configPath = "config/config.ini"
)

var dbUrl, sentryKey string
var err error

func GetKey(section string, key string) (string, error) {

	abs, err := filepath.Abs(configPath)
	cfg, err := ini.Load(abs)
	if err != nil {
		fmt.Printf("Fail to read file: %v", err)
		log.Panic(err)
		return "", err
		//os.Exit(1)
	}
	return cfg.Section(section).Key(key).String(), nil
}

func init() {

	// Mongodb
	dbUrl, err = GetKey("mongodb", "url")
	if err != nil {
		panic(err)
	}

	//Sentry
	sentryKey, err = GetKey("sentry", "key")
	if err != nil {
		panic(err)
	}

}

// ErrorReporter connection
func ErrorReporter(report string) {
	err := sentry.Init(sentry.ClientOptions{
		Dsn: sentryKey,
	})
	if err != nil {
		log.Fatalf("sentry.Init: %s", err)
	}
	defer sentry.Flush(2 * time.Second)

	sentry.CaptureMessage(report)

}

// ConnectDB ..
func ConnectDB() *mongo.Client {

	client, err := mongo.NewClient(options.Client().ApplyURI(dbUrl))
	if err != nil {
		log.Fatal(err)
	}

	ctx, _ := context.WithTimeout(context.Background(), 10*time.Second)
	err = client.Connect(ctx)
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Connected")
	// defer func() {
	// 	log.Println("DB disconnected from main")
	// 	err := client.Disconnect(context.Background())
	// 	if err != nil {
	// 		log.Println("db disc err ", err)
	// 	}
	// }()
	return client
}
