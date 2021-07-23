#ifndef CORE_FUNCTIONS_H
#define CORE_FUNCTIONS_H
#include <iostream>
#include <fstream>
#include <ctime>
#include <archive.h>
#include <archive_entry.h>
using namespace std;

// Get current date/time, format is YYYY-MM-DD.HH:mm:ss
const string currentDateTime() {
	time_t     now = time(0);
	struct tm  tstruct;
	char       buf[80];
	tstruct = *localtime(&now);
	strftime(buf, sizeof(buf), "%Y-%m-%d %X", &tstruct);

	return buf;
}

/**********************************************
 * Function for print error message on screen *
 **********************************************/

void error_msg(string ErrorMessage) {
	cout << "\e[1;31m" << ErrorMessage << "\e[0m\n";
}

/**********************************************
 *         Write message to log file          *
 *                                            *
 **********************************************
 * FORMAT:                                    *
 * [ DATE ] Function name: Message [ STATUS ] *
 *                                            *
 **********************************************
 * STATUSES:                                  *
 * 'OK' - Successful operation                *
 * 'Notice' - Simple message informing about  *
 * the progress of work                       *
 * 'Error' - Runtime error                    *
 * 'Fail' - Unsuccessful completion of the    *
 * operation                                  *
 * 'EMERG' - Unsuccessful completion of the   *
 * operation, inability to continue work      *
 *                                            *
 **********************************************
 * OPTIONS:                                   *
 * 'ok' - OK status                           *
 * 'notice' - Notice status                   *
 * 'err' - Error status                       *
 * 'fail' - Fail status                       *
 * 'emerg' - EMERG status                     *
 *                                            *
 **********************************************/ 
void log_msg(string Function, string Message, string Status) {	
	ofstream log("cpkg.log", ios_base::app);
	
	log << "[ " << currentDateTime() << " ] " << "Function '" << Function << "': " << Message << " [ " << Status << " ]\n";
	log.close();
}

// Функция для открытия файла со справкой
void print_text(string text) {
	string line;

	ifstream file(text);
	
	// Проверка на наличие файла
	if (file.is_open()) {
		while (getline(file, line)) {
			cout << line << endl; // Вывод информации из текста
		}
	} else {
		cout << "\a\e[1;31mОШИБКА: файл \e[0m\e[35m" << text << "\e[0m\e[1;31m не существует!\e[0m\n";
		exit(1); // Завершение программы с кодом ошибки 1
	}
	file.close(); // Закрытие файла
}

// Функция для записи информации в файл
void write_text(string text) {
	int i, num;
	string a;
	
	ofstream file(text, ios_base::app);
	
	cout << "Введите количество строк: ";
	cin >> num;
	
	for(i = 0; i < num; i++) {
		cin >> a;
		file << a << "\n"; // Запись числа в файл
	}
	
	file.close(); // Закрытие файла
}

#endif
