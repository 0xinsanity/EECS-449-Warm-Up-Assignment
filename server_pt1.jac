walker interact {
    can return_message with `root entry {
        report {
            "response": "Hello, world!"
        };
    }
}

walker interact_test1 {
    can return_message with `root entry {
        report {
            "response": "Testing worldwide"
        };
    }
}

walker interact_test2 {
    can return_message with `root entry {
        report {
            "response": "Testing worldwide pt 2"
        };
    }
}


walker interact_with_body {
    has name: str;

    can return_message with `root entry {
        report {
            "response": "Hello, " + self.name + "!"
        };
    }
}