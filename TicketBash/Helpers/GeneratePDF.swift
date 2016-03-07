//
//  GeneratePDF.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/9/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//
import UIKit
import RealmSwift
import Parse
import ParseUI
import JLPDFGenerator

func generatePDF (ticketData: Ticket) {
    let pdfGenerator = JLPDFGenerator()
    
    // style setup
    
    let nameFont = UIFont(name:"HelveticaNeue", size: 20.0)
    let paraFont = UIFont(name: "HelveticaNeue-Light",
        size: 15.0)
    let black = UIColor.blackColor()
    let center = NSTextAlignment.Center
    let right = NSTextAlignment.Right
    let left = NSTextAlignment.Left
    let size: CGSize = CGSizeMake(850, 1100)
//    let verticalMargin: Float = 100
//    let horizontalMargin: Float = 75
    
    let toAddress = "NYC Department of Finance\n" +
        "Hearings By Mail Unit\n" +
        "P.O. Box 29021\n" +
        "Cadman Plaza Station\n" +
    "Brooklyn, NY 11202-9021"
    let openingNotes = "\n\n\n\nTo Whom It May Concern\n\nI'm writing you to contest my parking ticket. Please find a picture of the parking citation and photographic evidence attached. "
    
    // create pdf
    pdfGenerator.setupPDFDocumentNamed("hahaPDF", withSize: size)
    
    
    // add first page
    pdfGenerator.beginPDFPage()
    
    // add content
    //// header
    pdfGenerator.addText("\(ticketData.firstName) \(ticketData.lastName)", withFrame: CGRectMake(0,77,850,1100), withFont: nameFont, withColor: black, textAlignment: center, verticalAlignment: 0)
    pdfGenerator.addText("\(ticketData.mailingAddress), \(ticketData.mailingAddress2)\ntel: \(ticketData.phoneNumber)", withFrame: CGRectMake(0,100,850,1100), withFont: paraFont, withColor: black, textAlignment: center, verticalAlignment: 0)
    //// draw lines
    pdfGenerator.addLineFromPoint(CGPointMake(75, 150), toEndPoint: CGPointMake(775, 150), withColor: black, andWidth: 0.5)
    
    //// body
    pdfGenerator.addText("\(toAddress)\(openingNotes)\(ticketData.explanationText)\n\nSincerely,\n\n\(ticketData.firstName) \(ticketData.lastName)\n\(ticketData.phoneNumber)", withFrame: CGRectMake(75, 200, 700, 1100), withFont: paraFont, withColor: black, textAlignment: left, verticalAlignment: 0)
    
    //// footer
    pdfGenerator.addLineFromPoint(CGPointMake(75, 1000), toEndPoint: CGPointMake(775, 1000), withColor: black, andWidth: 0.5)
    pdfGenerator.addText("Page 1 of 3", withFrame: CGRectMake(0,1025,775,1100), withFont: paraFont, withColor: black, textAlignment: right, verticalAlignment: 0)
    
    // page 2
    //// header
    pdfGenerator.addPageToPDF()
    pdfGenerator.addText("Exhibit A", withFrame: CGRectMake(0,77,850,1100), withFont: nameFont, withColor: black, textAlignment: center, verticalAlignment: 0)
    pdfGenerator.addText("Parking Citation", withFrame: CGRectMake(0,100,850,1100), withFont: paraFont, withColor: black, textAlignment: center, verticalAlignment: 0)
    //// draw lines
    pdfGenerator.addLineFromPoint(CGPointMake(75, 150), toEndPoint: CGPointMake(775, 150), withColor: black, andWidth: 0.5)
    
    //// body
    pdfGenerator.addImage(UIImage(data: ticketData.ticketPicture), inRect: CGRectMake(219, 225, 412, 700))
    
    //// footer
    pdfGenerator.addLineFromPoint(CGPointMake(75, 1000), toEndPoint: CGPointMake(775, 1000), withColor: black, andWidth: 0.5)
    pdfGenerator.addText("Page 2 of 3", withFrame: CGRectMake(0,1025,775,1100), withFont: paraFont, withColor: black, textAlignment: right, verticalAlignment: 0)
    
    // page 3
    //// header
    pdfGenerator.addPageToPDF()
    pdfGenerator.addText("Exhibit B", withFrame: CGRectMake(0,77,850,1100), withFont: nameFont, withColor: black, textAlignment: center, verticalAlignment: 0)
    pdfGenerator.addText("Photographic Evidence", withFrame: CGRectMake(0,100,850,1100), withFont: paraFont, withColor: black, textAlignment: center, verticalAlignment: 0)
    //// draw lines
    pdfGenerator.addLineFromPoint(CGPointMake(75, 150), toEndPoint: CGPointMake(775, 150), withColor: black, andWidth: 0.5)
    
    //// body
    pdfGenerator.addImage(UIImage(data: ticketData.evidencePicture), inRect: CGRectMake(162, 225, 526, 700))
    
    //// footer
    pdfGenerator.addLineFromPoint(CGPointMake(75, 1000), toEndPoint: CGPointMake(775, 1000), withColor: black, andWidth: 0.5)
    pdfGenerator.addText("Page 3 of 3", withFrame: CGRectMake(0,1025,775,1100), withFont: paraFont, withColor: black, textAlignment: right, verticalAlignment: 0)
    
    // save pdf, or if it exists, update it
    pdfGenerator.finishPDF()
}