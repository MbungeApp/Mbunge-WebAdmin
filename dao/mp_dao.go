package dao

import (
	"context"
	"fmt"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"mbunge-admin/models/db"
	"time"
)

type MPDaoInterface interface {
	ReadAllMp() ([]db.MP, error)
	ReadOneMp(mpID string) db.MP
	CreateMP(mp db.MP) error
	UpdateMPs(mpID string, key string, value string) error
	DeleteMPs(mpID string) error
}

type NewMPDaoInterface struct {
	Client *mongo.Client
}

func mpCollection(client *mongo.Client) *mongo.Collection {
	return client.Database("mbunge").Collection("mp")
}

func (m NewMPDaoInterface) ReadAllMp() ([]db.MP, error) {
	var mps []db.MP

	cursor, err := mpCollection(m.Client).Find(context.Background(), bson.M{})
	if err != nil {
		return nil, err
	}
	err = cursor.All(context.Background(), &mps)
	if err != nil {
		return nil, err
	}
	return mps, nil
}
func (m NewMPDaoInterface) ReadOneMp(mpID string) db.MP {
	objectID, _ := primitive.ObjectIDFromHex(mpID)
	var mp db.MP

	err := mpCollection(m.Client).FindOne(context.Background(), bson.D{{"_id", objectID}}).Decode(&mp)
	if err != nil {
		//log.Fatal(err)
		if err == mongo.ErrNoDocuments {
			return db.MP{}
		}
	}
	return mp
}
func (m NewMPDaoInterface) CreateMP(mp db.MP) error {
	mp.CreatedAt = time.Now()
	mp.UpdatedAt = time.Now()
	mp.ID = primitive.NewObjectID()
	_, err := mpCollection(m.Client).InsertOne(context.Background(), mp)
	if err != nil {
		return err
	}
	return nil
}
func (m NewMPDaoInterface) UpdateMPs(mpID string, key string, value string) error {
	var update bson.D
	objID, _ := primitive.ObjectIDFromHex(mpID)
	filter := bson.D{{"_id", objID}}
	if key == "date_birth" {
		layout := "2006-01-02"
		parsedDOB, _ := time.Parse(layout, value)
		update = bson.D{{Key: "$set", Value: bson.M{key: parsedDOB, "updated_at": time.Now()}}}
	} else {
		update = bson.D{{Key: "$set", Value: bson.M{key: value, "updated_at": time.Now()}}}
	}
	result, err := mpCollection(m.Client).UpdateOne(
		context.Background(),
		filter,
		update,
	)
	if err != nil {
		return err
	}
	if result.MatchedCount != 0 {
		fmt.Println("matched and replaced an existing document")
		return nil
	}
	if result.UpsertedCount != 0 {
		fmt.Printf("inserted a new document with ID %v\n", result.UpsertedID)
	}
	return nil
}
func (m NewMPDaoInterface) DeleteMPs(mpID string) error {
	objectID, _ := primitive.ObjectIDFromHex(mpID)
	_, err := mpCollection(m.Client).DeleteOne(context.Background(), bson.M{
		"_id": objectID,
	})
	if err != nil {
		return err
	}
	return nil
}
