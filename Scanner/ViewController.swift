//
//  ViewController.swift
//  Scanner
//
//  Created by Jan-Erik Revsbech on 11/03/17.
//  Copyright © 2017 Jan-Erik Revsbech. All rights reserved.
//

import Cocoa
//
class ViewController: NSViewController, ORSSerialPortDelegate  {
    @IBOutlet weak var serialportList: NSPopUpButton!
    @IBOutlet weak var connectionString: NSTextField!
    @IBOutlet weak var openCloseButton: NSButton!
    @IBOutlet var consoleOutput: NSTextView!
    @IBOutlet weak var serialCommand: NSTextField!
    
    let serialPortManager = ORSSerialPortManager.sharedSerialPortManager()
    var serialPort: ORSSerialPort?
    var l1state = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        for port in self.serialPortManager.availablePorts {
            serialportList.addItemWithTitle(port.path);
        }
        connectionString.stringValue = "Not connected";
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func clickSendCommand(sender: AnyObject) {
        print(self.serialCommand.stringValue);
        var command = self.serialCommand.stringValue;
        command += "\r\n";
        if (self.serialPort!.sendData(command.dataUsingEncoding(NSUTF8StringEncoding)!)) {
            print("Sending succedded");
            self.serialCommand.stringValue = "";
        } else {
            
            print("Unable to send");
        }

    }
    
    @IBAction func clickTurnCW(sender: NSButton) {
        let command = NSString(format: "T R 30\r\n");
        if (self.serialPort!.sendData(command.dataUsingEncoding(NSUTF8StringEncoding)!)) {
            print("Sending succedded");
        } else {
            print("Unable to send");
        }
    }
    
    @IBAction func openSerial(sender: NSButton) {
        self.consoleOutput.appendLine("Opening seraialport " + String(serialportList.selectedItem?.title));
        
        self.serialPort = ORSSerialPort(path: String(serialportList.selectedItem!.title))
        if (self.serialPort == nil) {
            consoleOutput.appendLine("Unable to open serial port");
            return
        }
        self.serialPort?.baudRate = 115200;
        self.serialPort?.delegate = self;
        self.serialPort?.open();
    }

    @IBAction func onL1Toggle(sender: NSButton) {
        if (self.serialPort == nil) {
            return;
        }
        self.toggleLaser(1, state: sender.state == NSOnState ? 1 : 0);
    }
    @IBAction func onL2Toggle(sender: NSButton) {
        if (self.serialPort == nil) {
            return;
        }
        self.toggleLaser(2, state: sender.state == NSOnState ? 1 : 0);
    }
    @IBAction func onL3Toggle(sender: NSButton) {
        if (self.serialPort == nil) {
            return;
        }
        self.toggleLaser(3, state: sender.state == NSOnState ? 1 : 0);
    }
    @IBAction func onL4Toggle(sender: NSButton) {
        if (self.serialPort == nil) {
            return;
        }
        self.toggleLaser(4, state: sender.state == NSOnState ? 1 : 0);
    }
    /**
     * Turn on/off laser
     */
    func toggleLaser(laserNumber: Int, state: Int) {
        let command = NSString(format: "L %d %d\r\n", laserNumber, state);
        print(command);
        if (self.serialPort!.sendData(command.dataUsingEncoding(NSUTF8StringEncoding)!)) {
            print("Sending succedded");
        } else {
            print("Unable to send");
        }
    }
    
    // MARK: - ORSSerialPortDelegate
    
    func serialPortWasOpened(serialPort: ORSSerialPort) {
        self.consoleOutput.appendLine("Serial port openend");
        self.connectionString.stringValue = "Connected!";
        self.serialPort?.sendData("sardauscan\n\r".dataUsingEncoding(NSUTF8StringEncoding)!);
    }
    
    func serialPortWasClosed(serialPort: ORSSerialPort) {
        self.consoleOutput.appendLine("Serial port closed");
        self.connectionString.stringValue = "Not connected";
    }
    
    func serialPort(serialPort: ORSSerialPort, didReceive data: NSData) {
        print("Incoming!!!!");
        /*
        if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            self.serialOutput.textStorage?.mutableString.append(string as String)
            self.serialOutput.needsDisplay = true
        }
*/
        let st = NSString(data: data, encoding: NSUTF8StringEncoding);
        print(st);
        consoleOutput.appendLine(String(st));
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
        self.serialPort = nil
        self.connectionString.stringValue = "Not connected";
    }
    
    
    func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
        consoleOutput.appendLine(String(error));
        print("SerialPort \(serialPort) encountered an error: \(error)")
    }
    
    func serialPort(serialPort: ORSSerialPort, didReceiveResponse responseData: NSData, toRequest request: ORSSerialRequest) {
        self.consoleOutput.appendLine("what up?");
    }
    
    func serialPort(serialPort: ORSSerialPort, requestDidTimeout request: ORSSerialRequest) {
        self.consoleOutput.appendLine("timeout");
    }

}

extension NSTextView {
    func append(string: String) {
        self.textStorage?.appendAttributedString(NSAttributedString(string: string))
        self.scrollToEndOfDocument(nil)
    }
    func appendLine(string: String) {
        self.append(string + "\n");
    }
}

