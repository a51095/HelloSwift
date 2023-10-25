//
//  BluetoothManager.swift
//  HelloSwift
//
//  Created by well on 2023/10/23.
//

import CoreBluetooth

class BluetoothManager: NSObject {
    weak var delegate: BleManagerDelegate?
    private var centralManager = CBCentralManager()
    private var connectedPeripheral: CBPeripheral?
    private var updateStatus: ((CBManagerState) -> Void)?
    private var didDiscoverPeripheral: ((DiscoverPeripheralResult) -> Void)?

    /// request authorization
    func requestAuthorization(status: @escaping (CBManagerState) -> Void) {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        updateStatus = status
    }

    /// start scanning
    func startScanning(_ serviceUUIDs: [CBUUID]? = nil, options: [String: Any]? = nil) {
        centralManager.scanForPeripherals(withServices: serviceUUIDs, options: options)
    }

    /// stop scan
    func stopScan() {
        centralManager.stopScan()
        kPrint("已停止蓝牙扫描")
    }

    /// connect
    func connect(_ peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        connectedPeripheral?.delegate = self
        centralManager.connect(peripheral, options: nil)
    }

    /// cancel
    func disconnect() {
        guard let peripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(peripheral)
        connectedPeripheral = nil
    }
}

extension BluetoothManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        updateStatus?(central.state)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // 发现外围设备，连接到它
        guard peripheral.name != nil else { return }
        let result = DiscoverPeripheralResult(peripheral: peripheral)
        delegate?.bleManagerDidDiscoverPeripheral(result: result)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("处理成功连接外设")
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("处理外设断开连接")
        central.cancelPeripheralConnection(peripheral)
    }
}

extension BluetoothManager {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.properties.contains(.read) {
                    peripheral.readValue(for: characteristic)
                }
                if characteristic.properties.contains(.write) {
                    // 写入数据到特征
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            let stringValue = String(data: data, encoding: .utf8)
            print("Received data: \(stringValue ?? "N/A")")
        }
    }
}

struct DiscoverPeripheralResult {
    let peripheral: CBPeripheral
}

protocol BleManagerDelegate: AnyObject {
    func bleManagerDidDiscoverPeripheral(result: DiscoverPeripheralResult)
}
