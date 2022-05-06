import time


if __name__ == "__main__":
    sleep_seconds = 20
    for i in list(range(sleep_seconds)):
        print(f"sleep {i}")
        time.sleep(1)
