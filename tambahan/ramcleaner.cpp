#include <iostream>
#include <windows.h>
#include <tchar.h>
#include <psapi.h>
#include <chrono>
#include <conio.h>

void BersihkanRAM(DWORD processID)
{
    TCHAR namaProses[MAX_PATH] = TEXT("<tidak diketahui>");

    // membuka handle proses
    HANDLE hProcess = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION |
                                      PROCESS_VM_READ | PROCESS_SET_LIMITED_INFORMATION | PROCESS_SET_QUOTA,
                                  FALSE, processID);

    if (NULL != hProcess)
    {
        HMODULE hMod;
        DWORD cbNeeded;

        // mendapatkan nama modul dasar suatu proses
        if (EnumProcessModules(hProcess, &hMod, sizeof(hMod),
                               &cbNeeded))
        {
            GetModuleBaseName(hProcess, hMod, namaProses,
                              sizeof(namaProses) / sizeof(TCHAR));
        }

        // melakukan operasi pembersihan RAM
        if (SetProcessWorkingSetSize(hProcess, -1, -1) != 1)
        {
            std::cout << "Gagal\t: " << namaProses << " (PID: " << processID << ")" << std::endl;
            CloseHandle(hProcess);
            return;
        }

        // menutup handle proses yang telah dibuka
        CloseHandle(hProcess);
    }

    std::cout << "Sukses\t: " << namaProses << " (PID: " << processID << ")" << std::endl;
}

int main()
{
    std::cout << "Created by Roland Vincent" << std::endl;
    std::cout << "C++ Application" << std::endl
              << std::endl;
    std::cout << "[] Starting RAM Cleaner" << std::endl;

    // menghitung waktu mulai program
    std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();

    DWORD aProcesses[1024], cbNeeded, cProcesses;
    unsigned int i;

    // mendapatkan ID proses dari seluruh proses yang sedang berjalan
    if (!EnumProcesses(aProcesses, sizeof(aProcesses), &cbNeeded))
        return 1;

    cProcesses = cbNeeded / sizeof(DWORD);

    // membersihkan RAM pada setiap proses yang sedang berjalan
    for (i = 0; i < cProcesses; i++)
    {
        if (aProcesses[i] != 0)
        {
            BersihkanRAM(aProcesses[i]);
        }
    }

    // menghitung waktu selesai program
    std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();
    std::cout << "[] Finished in " << std::chrono::duration_cast<std::chrono::milliseconds>(end - begin).count() << " ms" << std::endl;
    std::cout << "[Tekan tombol apa saja untuk melanjutkan]";
    _getch();
    return 0;
}
