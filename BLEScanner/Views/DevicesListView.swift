//
//  DevicesListView.swift
//  BLEScanner
//
//  Created by Anna Koulaeva on 17.02.2023.
//

import SwiftUI

struct DevicesListView: View {
    private enum StringConstants {
        static let getDevices = "Start scanning for devices"
        static let stopScanning = "Stop Scanning"
        static let connect = "Connect"
        static let ok = "Ok"
        static let device = "Device"
    }
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                if !viewModel.peripheralsDisplayData.isEmpty {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewModel.peripheralsDisplayData, id: \.self) { peripheral in
                                peripheralView(for: peripheral)
                            }
                        }
                    }
                        .padding(.vertical, UIConstants.Padding.large)
                        .navigationDestination(isPresented: $viewModel.shouldShowDeviceInfoView) {
                            ConnectedDeviceInfoView(shouldDisconnectCurrentDevice: $viewModel.shouldShowDeviceInfoView,
                                                    deviceInfo: $viewModel.connectedDeviceInfo)
                        }
                    
                    Spacer()
                }
                
                if viewModel.isScanningForDevices {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding(.bottom, UIConstants.Padding.large)
                    
                    Spacer()
                }
                
                getDevicesButton
                    .padding(.bottom, UIConstants.Padding.medium)
                    .alert(isPresented: $viewModel.shoudShowBLEProblemAlert) {
                        connecionFailedAlertView
                    }
            }
            .onChange(of: viewModel.shouldShowDeviceInfoView) { newValue in
                if !newValue {
                    viewModel.disconnectCurrentDevice()
                }
            }
        }
    }
    
    //MARK: -Additional views
    private var getDevicesButton: some View {
        VStack {
            Button {
                if viewModel.isScanningForDevices {
                    viewModel.stopScanningForConnections()
                } else {
                    viewModel.scanConnections()
                }
            } label: {
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.normal)
                    .foregroundColor(UIConstants.mainColor)
                    .overlay(
                        Text(viewModel.isScanningForDevices ? StringConstants.stopScanning : StringConstants.getDevices)
                            .foregroundColor(.white)
                            .font(.title)
                            .minimumScaleFactor(0.85)
                            .padding(.horizontal, UIConstants.Padding.small)
                    )
                    .frame(height: UIConstants.screenHeight * 0.1)
                    .padding(.horizontal, UIConstants.Padding.xlarge)
            }
                .disabled(viewModel.connectionError != nil)
                .opacity(viewModel.connectionError != nil ? 0.7 : 1)
        }
    }
    
    private var connecionFailedAlertView: Alert {
        Alert(title: Text(viewModel.connectionError?.title ?? ""),
              message: Text(viewModel.connectionError?.description ?? ""),
              dismissButton: .default(Text(StringConstants.ok),
                                      action: viewModel.connectionError?.okButtonAction))
    }
    
    private var deviceDisconnectedAlertView: Alert {
        Alert(title: Text("\(viewModel.connectedDeviceInfo?.peripheralData.name ?? StringConstants.device) is disconnected"),
              dismissButton: .default(Text(StringConstants.ok),
                                      action: {
            viewModel.deviceDisconnected = false
            viewModel.connectedDeviceInfo = nil
        }))
    }
    
    //MARK: -Additional views functions
    func peripheralView(for peripheral: PeripheralData) -> some View {
        ZStack {
            Rectangle()
                .stroke(.gray, lineWidth: 1)
                .foregroundColor(.gray)
            
            HStack {
                Text(peripheral.name)
                
                Spacer()
                
                Button {
                    viewModel.connectTo(deviceId: peripheral.identifier)
                } label: {
                    RoundedRectangle(cornerRadius: UIConstants.CornerRadius.small)
                        .foregroundColor(.gray.opacity(0.5))
                        .overlay(
                            VStack {
                                if let isConnectingToDeviceWithId = viewModel.isConnectingToDeviceWithId,
                                   isConnectingToDeviceWithId == peripheral.identifier {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                } else {
                                    Text(StringConstants.connect)
                                        .foregroundColor(.white)
                                }
                            }
                        )
                }
                    .frame(width: UIConstants.screenWidth * 0.25)
                    .padding(.vertical, UIConstants.Padding.small)
                    .alert(isPresented: $viewModel.deviceDisconnected) {
                        deviceDisconnectedAlertView
                    }
            }
                .padding(.horizontal, UIConstants.Padding.small)
        }
            .frame(height: UIConstants.screenHeight * 0.1)
            .padding(.horizontal, UIConstants.Padding.large)
    }
}

struct DevicesListView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesListView()
    }
}
